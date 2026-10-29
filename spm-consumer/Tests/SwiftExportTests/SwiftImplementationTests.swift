import Testing
import Shared
import KotlinRuntime

// A Swift implementation of the Kotlin UserRepository interface: a Flow property
// and a suspend function, backed by a Kotlin MutableStateFlow from mutableStateFlow(initial:)
final class SwiftUserRepository: KotlinBase, UserRepository {
    private let user = mutableStateFlow(initial: "")

    var signedInUser: any KotlinTypedFlow<String> { user }

    func signInUser(user: String) async throws {
        self.user.value = user
    }
}

struct SwiftImplementationTests {

    @Test func kotlinConsumesTheSwiftRepository() async throws {
        let repository = SwiftUserRepository()
        let viewModel = SignInViewModel(repository: repository)

        var greetings: [String] = []
        for try await greeting in viewModel.greeting.asAsyncSequence() {
            greetings.append(greeting)
            if greetings.count == 1 {
                try await viewModel.signIn(user: "Alice")
            }
            if greetings.count == 2 {
                break
            }
        }
        #expect(greetings == ["Nobody is signed in", "Hello, Alice!"])
    }

    @Test func signInTrimsTheName() async throws {
        // The Kotlin InMemoryUserRepository, for comparison with the Swift one
        let viewModel = SignInViewModel(repository: InMemoryUserRepository())

        var greetings: [String] = []
        for try await greeting in viewModel.greeting.asAsyncSequence() {
            greetings.append(greeting)
            if greetings.count == 1 {
                try await viewModel.signIn(user: "  Bob ")
            }
            if greetings.count == 2 {
                break
            }
        }
        #expect(greetings == ["Nobody is signed in", "Hello, Bob!"])
    }
}
