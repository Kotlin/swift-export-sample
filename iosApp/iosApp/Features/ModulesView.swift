import SwiftUI
import Shared
import ModuleA
import ModuleB

struct ModulesView: View {
    var body: some View {
        FeatureScreen(
            title: "Modules",
            summary: "Each `api` dependency of `:shared` is its own Swift module. `:module-a` configures its Swift name in its own build script; `:module-b` has no configuration, so `:shared` names it with `configure(projects.moduleB) { ... }`."
        ) {
            Section("import ModuleA (configured by the library)") {
                DemoRow("ClassFromA(name: \"A\").hello()", ClassFromA(name: "A").hello())
                DemoRow("iosModuleABar()", iosModuleABar())
            }
            Section("import ModuleB (configured by the consumer)") {
                DemoRow("ClassFromB(name: \"B\").hello()", ClassFromB(name: "B").hello())
                DemoRow("iosModuleBBar()", iosModuleBBar())
            }
            Section("import Shared (types from other modules in its API)") {
                DemoRow("makeClassFromA().hello()", makeClassFromA().hello())
                DemoRow("makeClassFromB().hello()", makeClassFromB().hello())
            }
        }
    }
}
