import SwiftUI
import Shared

struct FlowsView: View {
    private let feed = UserFeed(repository: UserRepository())
    @State private var received: [User] = []

    var body: some View {
        FeatureScreen(
            title: "Flows",
            summary: "`val users: Flow<User>` is `any KotlinTypedFlow<User>`. `asAsyncSequence()` turns it into a throwing AsyncSequence of `User`, so no casts are needed. Leaving the screen cancels the collection."
        ) {
            Section("for try await user in feed.users.asAsyncSequence()") {
                ForEach(received, id: \.name) { user in
                    Text("\(user.name), \(user.age)")
                }
            }
        }
        .task {
            received.removeAll()
            do {
                for try await user in feed.users.asAsyncSequence() {
                    received.append(user)
                }
            } catch {
                // CancellationError when the screen goes away.
            }
        }
    }
}
