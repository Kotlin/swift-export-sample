import SwiftUI
import Shared

/// Swift subclass that overrides a Kotlin suspend function with an async method.
final class SwiftRepository: Repository {
    override func fetch(id: Int32) async throws -> String {
        "Swift item \(id)"
    }
}

struct CoroutinesView: View {
    @State private var viewModel = UsersViewModel()
    @State private var isShowingFlow = false
    @State private var users: Result<[User], Error>?
    @State private var items: Result<[String], Error>?
    @State private var loadingResult = "loading…"
    @State private var selectedName = "nil"
    @State private var queryValue = ""
    @State private var events: [String] = []
    @State private var countdown = Countdown()
    @State private var countdownTask: Task<Void, Never>?
    @State private var countdownStatus = "not started"

    var body: some View {
        FeatureScreen(
            title: "Coroutines",
            summary: "`suspend fun` becomes `async throws`, and a suspend lambda parameter is an `async` Swift closure. `Flow<User>` is `any KotlinTypedFlow<User>`, a typed `AsyncSequence` via `asAsyncSequence()`; `StateFlow` exposes `value`, a `MutableStateFlow` value can be set from Swift, and a `SharedFlow` is collected with `break`, because it never completes. Cancelling the Swift `Task` cancels the Kotlin coroutine."
        ) {
            Section("suspend fun") {
                DemoRow("try await viewModel.loadUsers()", describe(users) { $0.map(\.name).joined(separator: ", ") })
                DemoRow("try await fetchAll(repository: SwiftRepository(), ids: [1, 2])", describe(items) { $0.joined(separator: ", ") })
                DemoRow(#"try await viewModel.withLoading { "from Swift" }"#, loadingResult)
            }
            Section("Flow, StateFlow, SharedFlow") {
                Button("Collect viewModel.users in a sheet") {
                    isShowingFlow = true
                }
                DemoRow("viewModel.selected.value (StateFlow<User?>)", selectedName)
                DemoRow(#"viewModel.query.value (MutableStateFlow<String>)"#, queryValue)
                DemoRow("viewModel.events (SharedFlow<String>, replay: 10)", events.joined(separator: ", "))
                Button(#"viewModel.select(user: User(name: "Jane", age: 25))"#) {
                    viewModel.select(user: User(name: "Jane", age: 25))
                }
                .buttonStyle(.borderless)
                Button(#"viewModel.query.value = "kotlin""#) {
                    viewModel.query.value = "kotlin"
                    queryValue = viewModel.query.value
                }
                .buttonStyle(.borderless)
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
                .buttonStyle(.borderless)
                DemoRow("waitForever { … }", "suspends until the Task is cancelled")
            }
        }
        .sheet(isPresented: $isShowingFlow) {
            // Presented from outside the List sections: a presentation attached to a List
            // section is dismissed when the List rebuilds that section, for example after a load
            UsersFlowView(viewModel: viewModel)
                #if os(macOS)
                // A List has no ideal size, so give the macOS sheet one
                .frame(minWidth: 320, minHeight: 280)
                #endif
        }
        .task {
            guard users == nil || items == nil else { return }
            // The two calls don't depend on each other, so they run concurrently.
            // A cancelled load returns nil, so the next .task loads again.
            async let loadedUsers = load { try await viewModel.loadUsers() }
            async let loadedItems = load { try await fetchAll(repository: SwiftRepository(), ids: [1, 2]) }
            users = await loadedUsers
            items = await loadedItems
            loadingResult = (try? await viewModel.withLoading { "from Swift" }) ?? "failed"
        }
        .task {
            do {
                for try await user in viewModel.selected.asAsyncSequence() {
                    selectedName = user?.name ?? "nil"
                }
            } catch {}
        }
        .task {
            do {
                for try await event in viewModel.events.asAsyncSequence() {
                    events.append(event)
                }
            } catch {}
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

    /// Returns nil when the task is cancelled, so the next `.task` loads again
    private func load<T>(_ body: () async throws -> T) async -> Result<T, Error>? {
        do {
            return .success(try await body())
        } catch is CancellationError {
            return nil
        } catch {
            return .failure(error)
        }
    }

    private func describe<T>(_ result: Result<T, Error>?, _ success: (T) -> String) -> String {
        switch result {
        case nil: "loading…"
        case .success(let value): success(value)
        case .failure(let error): "Failed: \(error)"
        }
    }
}

struct UsersFlowView: View {
    let viewModel: UsersViewModel
    @State private var items: [User] = []
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { user in
                    Text("\(user.name), aged \(user.age)")
                }
                if let error {
                    Text("Flow failed: \(error.localizedDescription)")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                await collectUsers()
            }
        }
    }

    private func collectUsers() async {
        items.removeAll()
        error = nil
        do {
            // No casts are needed, the flow elements are typed as User
            for try await user in viewModel.users.asAsyncSequence() {
                items.append(user)
            }
        } catch is CancellationError {
            // Dismissing the sheet cancels the task, which cancels the Kotlin flow
        } catch {
            self.error = error
        }
    }
}
