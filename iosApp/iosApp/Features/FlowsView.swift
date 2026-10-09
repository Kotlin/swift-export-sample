import SwiftUI
import Shared

struct FlowsView: View {
    private let feed = UserFeed(repository: UserRepository())
    private let counter = ClickCounter()
    @State private var received: [User] = []
    @State private var clicks: Int32 = 0
    @State private var label = ""

    var body: some View {
        FeatureScreen(
            title: "Flows",
            summary: "`val users: Flow<User>` is `any KotlinTypedFlow<User>`. `asAsyncSequence()` turns it into a throwing AsyncSequence of `User`, so no casts are needed. `StateFlow` adds a typed `value`; a `MutableStateFlow` can be set from Swift."
        ) {
            Section("for try await user in feed.users.asAsyncSequence()") {
                ForEach(received, id: \.name) { user in
                    Text("\(user.name), \(user.age)")
                }
            }
            Section("StateFlow<Int> and MutableStateFlow<String>") {
                DemoRow("counter.clicks (collected)", clicks)
                DemoRow("counter.clicks.value", counter.clicks.value)
                Button("\(label): counter.click()") {
                    counter.click()
                }
                Button("counter.label.value = \"Taps\"") {
                    counter.label.value = "Taps"
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
        .task {
            do {
                for try await value in counter.clicks.asAsyncSequence() {
                    clicks = value
                }
            } catch {}
        }
        .task {
            do {
                for try await value in counter.label.asAsyncSequence() {
                    label = value
                }
            } catch {}
        }
    }
}
