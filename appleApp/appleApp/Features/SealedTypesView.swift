import SwiftUI
import Shared

struct SealedTypesView: View {
    // Stored once, so every state keeps a stable identity across body updates
    @State private var states = loadingStates()

    var body: some View {
        FeatureScreen(
            title: "Sealed types",
            summary: "A sealed hierarchy gets a generated `<Name>_SealedType` Swift enum with one case per subclass, so `switch state.sealedType()` is exhaustive without `default`. The payload's `.value` is the subclass instance, and sealed interfaces work the same way."
        ) {
            Section("switch state.sealedType()") {
                ForEach(states, id: \.self) { state in
                    DemoRow("loadingStates()[…].sealedType()", describe(state))
                }
            }
            Section("Sealed interface") {
                DemoRow(#"execute(command: Command.Move(steps: 3))"#, execute(command: Command.Move(steps: 3)))
                DemoRow("execute(command: Command.Stop.shared)", execute(command: Command.Stop.shared))
                DemoRow("Command.Move(steps: 3).copy(steps: 5).steps — data class copy", Command.Move(steps: 3).copy(steps: 5).steps)
            }
            Section("Subclasses are nested Swift classes") {
                DemoRow("LoadingState.Loading.shared === states[0]", LoadingState.Loading.shared === states[0])
                DemoRow(#"(states[1] as? LoadingState.Success)?.data"#, (states[1] as? LoadingState.Success)?.data)
            }
        }
    }

    private func describe(_ state: LoadingState) -> String {
        switch state.sealedType() {
        case .loading: "Loading…"
        case .success(let success): "Success: \(success.value.data)"
        case .error(let error): "Error: \(error.value.message)"
        }
    }
}
