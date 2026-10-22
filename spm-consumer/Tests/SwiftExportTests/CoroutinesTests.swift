import Testing
import Shared

// Swift subclass that overrides a Kotlin suspend function with an async method
final class CachedRepository: Repository {
    override func fetch(id: Int32) async throws -> String {
        try await Task.sleep(for: .milliseconds(1))
        return "Swift item \(id)"
    }
}

struct CoroutinesTests {

    @Test func suspendFunctionsAreAsync() async throws {
        let users = try await UsersViewModel().loadUsers()
        #expect(users.map(\.name) == ["John Doe", "Jane Doe"])
    }

    @Test func flowsAreAsyncSequences() async throws {
        var names: [String] = []
        for try await user in UsersViewModel().users.asAsyncSequence() {
            names.append(user.name)
        }
        #expect(names == ["John Doe", "Jane Doe"])
    }

    @Test func stateFlowValue() {
        let viewModel = UsersViewModel()
        #expect(viewModel.selected.value == nil)
        viewModel.select(user: User(name: "Jane", age: 25))
        #expect(viewModel.selected.value?.name == "Jane")
    }

    @Test func mutableStateFlowValue() {
        let viewModel = UsersViewModel()
        viewModel.query.value = "Jane"
        #expect(viewModel.query.value == "Jane")
    }

    @Test func sharedFlows() async throws {
        let viewModel = UsersViewModel()
        viewModel.select(user: User(name: "Jane", age: 25))
        viewModel.select(user: User(name: "John", age: 30))
        var events: [String] = []
        // A SharedFlow never completes, so stop collecting explicitly
        for try await event in viewModel.events.asAsyncSequence() {
            events.append(event)
            if events.count == 2 { break }
        }
        #expect(events == ["Selected Jane", "Selected John"])
    }

    @Test func swiftOverridesOfSuspendFunctions() async throws {
        #expect(try await fetchAll(repository: Repository(), ids: [1]) == ["Kotlin item 1"])
        #expect(try await fetchAll(repository: CachedRepository(), ids: [1, 2]) == ["Swift item 1", "Swift item 2"])
    }

    @Test func suspendFunctionTypes() async throws {
        let result = try await UsersViewModel().withLoading {
            try await Task.sleep(for: .milliseconds(10))
            return "from Swift"
        }
        #expect(result == "Loaded: from Swift")
    }

    @Test func cancellationIsPropagatedToKotlin() async throws {
        let cancelled = Flag()
        let task = Task {
            try await waitForever { cancelled.set() }
        }
        try await Task.sleep(for: .milliseconds(100))
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
        #expect(cancelled.value)
    }
}

final class Flag: @unchecked Sendable {
    private(set) var value = false
    func set() { value = true }
}
