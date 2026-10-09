import SwiftUI
import Shared
import KotlinRuntime

/// A Swift implementation of the Kotlin `UserRepository` interface.
///
/// Swift can't create a Kotlin `Flow`, so it asks Kotlin for a `MutableStateFlow`
/// (`mutableStateFlow(initial:)`) and keeps it, just like an Android implementation would.
final class SwiftUserRepository: KotlinBase, UserRepository {
    private let user = mutableStateFlow(initial: "")

    var signedInUser: any KotlinTypedFlow<String> { user }

    func signInUser(user: String) async throws {
        try await Task.sleep(for: .milliseconds(300)) // pretend to talk to a server
        self.user.value = user
    }
}

struct SwiftImplementationView: View {
    private let viewModel: SignInViewModel
    @State private var name = "Alice"
    @State private var greeting = ""
    @State private var isSigningIn = false

    init() {
        // Kotlin code receives the Swift implementation as `any UserRepository`.
        self.viewModel = SignInViewModel(repository: SwiftUserRepository())
    }

    var body: some View {
        FeatureScreen(
            title: "Implementing in Swift",
            summary: "The Kotlin interface `UserRepository` has a `Flow<String>` property and a `suspend fun`. Swift implements them as `var signedInUser: any KotlinTypedFlow<String>` and `func signInUser(user:) async throws`, using a `MutableStateFlow` from the Kotlin builder `mutableStateFlow(initial:)`. Kotlin's `SignInViewModel` uses the Swift implementation."
        ) {
            Section("Kotlin SignInViewModel → Swift SwiftUserRepository") {
                TextField("User name", text: $name)
                    .textInputAutocapitalization(.words)
                Button(isSigningIn ? "Signing in…" : "try await viewModel.signIn(user: name)") {
                    signIn()
                }
                .disabled(isSigningIn || name.isEmpty)
            }
            Section("viewModel.greeting (Kotlin map over the Swift flow)") {
                Text(greeting)
            }
        }
        .task {
            do {
                for try await value in viewModel.greeting.asAsyncSequence() {
                    greeting = value
                }
            } catch {}
        }
    }

    private func signIn() {
        isSigningIn = true
        Task {
            try? await viewModel.signIn(user: name)
            isSigningIn = false
        }
    }
}
