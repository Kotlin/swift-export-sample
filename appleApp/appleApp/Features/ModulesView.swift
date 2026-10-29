import SwiftUI
import Shared
import ModuleA
import ModuleB
import ModuleC

struct ModulesView: View {
    var body: some View {
        FeatureScreen(
            title: "Modules",
            summary: "Each `api` dependency of `:shared` is its own Swift module: `:module-a` names itself in its build script, and `:shared` names `:module-b` via `configure(projects.moduleB) { ... }`. An `implementation` dependency is exported partially by default: `:module-c` is exported fully with `SwiftExportVisibility.EXPOSED`. `:module-d` and Koin are hidden with `HIDDEN`, shown on the Hiding a dependency screen. Declarations outside `rootPackage` keep their package as a namespace."
        ) {
            Section("import ModuleA — configured by the library") {
                DemoRow(#"ClassFromA(name: "A").hello()"#, ClassFromA(name: "A").hello())
                DemoRow("useClassFromA().hello()", useClassFromA().hello())
                #if os(iOS)
                DemoRow("iosModuleABar() — module-a's iosMain", iosModuleABar())
                #endif
            }
            Section("import ModuleB — configured by the consumer") {
                DemoRow(#"ClassFromB(name: "B").hello()"#, ClassFromB(name: "B").hello())
                DemoRow("useClassFromB().hello()", useClassFromB().hello())
                #if os(iOS)
                DemoRow("iosModuleBBar() — module-b's iosMain", iosModuleBBar())
                #endif
            }
            Section("EXPOSED: import ModuleC in full") {
                DemoRow("moduleCFunction()", moduleCFunction())
                DemoRow("analytics() → .track(event:) → .trackedEvents().count", trackAndCount())
            }
            Section("Nested packages keep their namespace") {
                DemoRow("nested.NestedPackageClass().hello()", nested.NestedPackageClass().hello())
                DemoRow("nested.nestedPackageFunction()", nested.nestedPackageFunction())
            }
        }
    }

    private func trackAndCount() -> Int {
        let analytics = analytics()
        analytics.track(event: Event(name: "screen", properties: ["name": "Modules"]))
        return analytics.trackedEvents().count
    }
}
