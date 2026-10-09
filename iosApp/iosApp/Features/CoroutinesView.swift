import SwiftUI
import Shared

struct CoroutinesView: View {
    private let loader = UserLoader()
    @State private var users: [User]?
    @State private var launched = "waiting…"
    @State private var countdown = Countdown()
    @State private var countdownTask: Task<Void, Never>?
    @State private var countdownStatus = "not started"

    var body: some View {
        FeatureScreen(
            title: "Coroutines",
            summary: "`suspend fun loadUsers(): List<User>` is `func loadUsers() async throws -> [User]`. A `suspend () -> Unit` parameter is an async Swift closure. Cancelling the Swift Task cancels the Kotlin coroutine."
        ) {
            Section("suspend fun and suspend lambdas") {
                DemoRow("try await loader.loadUsers()", users.map { $0.map(\.name).joined(separator: ", ") } ?? "loading…")
                DemoRow("loader.launch { await … }", launched)
            }
            Section("Cancellation") {
                DemoRow("try await countdown.run(from: 5)", countdownStatus)
                Button(countdownTask == nil ? "Start countdown" : "Cancel Task") {
                    if let task = countdownTask {
                        task.cancel()
                    } else {
                        startCountdown()
                    }
                }
            }
        }
        .task {
            users = try? await loader.loadUsers()
        }
        .onAppear {
            // No async context here, but the closure is async: it may await.
            loader.launch {
                let count = try await loader.loadUsers().count
                await MainActor.run { launched = "loaded \(count) users inside a Kotlin coroutine" }
            }
        }
    }

    private func startCountdown() {
        let countdown = Countdown()
        self.countdown = countdown
        countdownStatus = "running for 5 s…"
        countdownTask = Task {
            do {
                let result = try await countdown.run(from: 5)
                countdownStatus = "finished: \(result)"
            } catch is CancellationError {
                countdownStatus = "CancellationError; Kotlin saw cancellation: \(countdown.wasCancelled)"
            } catch {
                countdownStatus = "\(error)"
            }
            countdownTask = nil
        }
    }
}
