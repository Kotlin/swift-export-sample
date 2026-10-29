import SwiftUI
import Shared

struct HiddenDependencyView: View {
    @State private var confirmTrap = false

    var body: some View {
        FeatureScreen(
            title: "Hiding a dependency",
            summary: "Koin leaks into the public API through `AppGraph.koin` and `AppGraph.modules()`. `:shared` hides it with `configure(libs.koin.core, SwiftExportVisibility.HIDDEN)`, so Koin's types are empty stubs and the leaked declarations trap when called. Swift uses the wrapper instead. The same visibility hides `:module-d`, whose `Engine` becomes an empty stub that `Car` still inherits from."
        ) {
            Section("Wrapper API: only our own types") {
                DemoRow("AppGraph.shared.greetingService().welcome(name: \"Swift\")", AppGraph.shared.greetingService().welcome(name: "Swift"))
            }
            Section("Leaked API: compiles, but has no implementation") {
                DemoRow("AppGraph.shared.koin", "type Koin: an empty stub class, so `.get()` doesn't compile")
                DemoRow("AppGraph.shared.modules()", "[Module]: the body is fatalError()")
                Button("Call AppGraph.shared.koin (crashes the app)", role: .destructive) {
                    confirmTrap = true
                }
            }
            Section("The same HIDDEN hides :module-d") {
                DemoRow("Car().drive() — Car : Engine, Engine is an empty stub", Car().drive())
            }
            Section("Generated Swift for Koin") {
                DemoRow("without HIDDEN", "IoInsertKoinKoinCore.swift: 1,818 lines; KotlinStdlib.swift: 2,341 lines")
                DemoRow("with HIDDEN", "IoInsertKoinKoinCore.swift: 23 lines, 2 empty stubs; KotlinStdlib.swift: 1,711 lines")
            }
        }
        .confirmationDialog("This calls a fatalError() stub and terminates the app.", isPresented: $confirmTrap, titleVisibility: .visible) {
            Button("Crash", role: .destructive) {
                _ = AppGraph.shared.koin
            }
        }
    }
}
