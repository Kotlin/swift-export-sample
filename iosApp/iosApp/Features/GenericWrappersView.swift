import SwiftUI
import Shared

struct GenericWrappersView: View {
    private let loader = ProfileLoader()
    private let model = ProfileScreenModel(loader: ProfileLoader())
    @State private var genericState = "not loaded"
    @State private var wrappedState = "not loaded"
    @State private var wrappedHeadline = "–"
    @State private var loading: Task<Void, Never>?

    var body: some View {
        FeatureScreen(
            title: "Generic wrappers",
            summary: "`ScreenState<T>` with `Ready<T>(data: T)` is erased in Swift: `data` is `(any _KotlinBridgeable)?`, and `headline(state: ScreenState<Profile>)` isn't exported at all. The non-generic `ProfileState` wrapper, mapped in Kotlin, gives Swift a typed `profile` and no casts."
        ) {
            Section("Generic: loader.load(succeed:) → Flow<ScreenState<Profile>>") {
                DemoRow("case .ready(let r): r.value.data as? Profile", genericState)
                DemoRow("headline(state: ScreenState<Profile>)", "not exported")
                loadButtons { succeed in
                    for try await state in loader.load(succeed: succeed).asAsyncSequence() {
                        genericState = render(state)
                    }
                }
            }
            Section("Wrapper: model.load(succeed:) → Flow<ProfileState>") {
                DemoRow("case .ready(let r): r.value.profile", wrappedState)
                DemoRow("model.headline(state:)", wrappedHeadline)
                loadButtons { succeed in
                    for try await state in model.load(succeed: succeed).asAsyncSequence() {
                        wrappedState = render(state)
                        wrappedHeadline = model.headline(state: state)
                    }
                }
            }
        }
        .onDisappear { loading?.cancel() }
    }

    /// The generic class: every payload has to be cast back.
    private func render(_ state: ScreenState) -> String {
        switch state.sealedType() {
        case .loading: "Loading…"
        case .ready(let ready):
            if let profile = ready.value.data as? Profile {
                "\(profile.name), \(profile.followers) followers"
            } else {
                "unexpected data: \(String(describing: ready.value.data))"
            }
        case .error(let error): "Error: \(error.value.message)"
        }
    }

    /// The wrapper: payloads are typed.
    private func render(_ state: ProfileState) -> String {
        switch state.sealedType() {
        case .loading: "Loading…"
        case .ready(let ready): "\(ready.value.profile.name), \(ready.value.profile.followers) followers"
        case .error(let error): "Error: \(error.value.message)"
        }
    }

    private func loadButtons(_ collect: @escaping (Bool) async throws -> Void) -> some View {
        HStack {
            Button("Load") { start { try await collect(true) } }
            Spacer()
            Button("Load with error") { start { try await collect(false) } }
        }
        .buttonStyle(.borderless)
    }

    private func start(_ work: @escaping () async throws -> Void) {
        loading?.cancel()
        loading = Task { try? await work() }
    }
}
