import SwiftUI
import Shared

struct SealedView: View {
    var body: some View {
        FeatureScreen(
            title: "Sealed classes",
            summary: "`sealedType()` returns a Swift enum with one case per subclass, so Swift can switch over a sealed hierarchy exhaustively. The payload's `.value` is the subclass instance."
        ) {
            Section("switch loadStateFor(step:).sealedType()") {
                ForEach(0..<3) { step in
                    DemoRow("loadStateFor(step: \(step))", render(loadStateFor(step: Int32(step))))
                }
            }
            Section("Subclasses are nested Swift classes") {
                DemoRow("LoadState.Loading.shared === loadStateFor(step: 0)", LoadState.Loading.shared === loadStateFor(step: 0))
                DemoRow("(loadStateFor(step: 1) as? LoadState.Loaded)?.items", (loadStateFor(step: 1) as? LoadState.Loaded)?.items.joined(separator: ", ") ?? "nil")
                DemoRow("LoadState.Failed(reason: \"a\").copy(reason: \"b\").reason", LoadState.Failed(reason: "a").copy(reason: "b").reason)
            }
        }
    }

    private func render(_ state: LoadState) -> String {
        switch state.sealedType() {
        case .loading: "Loading…"
        case .loaded(let loaded): "Loaded \(loaded.value.items.joined(separator: ", "))"
        case .failed(let failed): "Failed: \(failed.value.reason)"
        }
    }
}
