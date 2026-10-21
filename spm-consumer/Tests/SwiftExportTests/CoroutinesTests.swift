import Testing
import Shared

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
