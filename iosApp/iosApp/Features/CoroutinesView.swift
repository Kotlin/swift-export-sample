import SwiftUI
import Shared

struct CoroutinesView: View {
    private let repository = UserRepository()
    @State private var users: [User]?
    @State private var launched = "waiting…"

    var body: some View {
        FeatureScreen(
            title: "Coroutines",
            summary: "`suspend fun loadUsers(): List<User>` is `func loadUsers() async throws -> [User]`. A `suspend () -> Unit` parameter is an async Swift closure, so its body can `await` even when the caller isn't async."
        ) {
            DemoRow("try await repository.loadUsers()", users.map { $0.map(\.name).joined(separator: ", ") } ?? "loading…")
            DemoRow("repository.launch { await … }", launched)
        }
        .task {
            users = try? await repository.loadUsers()
        }
        .onAppear {
            // No async context here, but the closure is async: it may await.
            repository.launch {
                let count = try await repository.loadUsers().count
                await MainActor.run { launched = "loaded \(count) users inside a Kotlin coroutine" }
            }
        }
    }
}
