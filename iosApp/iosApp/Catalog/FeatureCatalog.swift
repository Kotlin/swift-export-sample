import SwiftUI

/// Entry point of the sample: one row per Swift Export feature.
/// Each feature has a Kotlin file in `shared/src/commonMain` and a screen in `Features/`
/// with the same name, e.g. `Sealed.kt` and `SealedView.swift`.
struct FeatureCatalog: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Basics") {
                    FeatureLink("Classes", "nested and inner classes, typealiases, objects, companions") { ClassesView() }
                    FeatureLink("Functions", "top-level functions, overloads, vararg, @ObjCName") { FunctionsView() }
                    FeatureLink("Extensions", "Kotlin extensions → Swift extensions") { ExtensionsView() }
                    FeatureLink("Operators", "operator fun → Swift operators and subscripts") { OperatorsView() }
                    FeatureLink("Annotations & docs", "KDoc, @Deprecated, @HiddenFromObjC") { AnnotationsView() }
                }
                Section("Type hierarchy") {
                    FeatureLink("Interfaces", "protocols, Swift implementations of Kotlin interfaces") { InterfacesView() }
                    FeatureLink("Inheritance", "open/abstract classes, Swift subclasses") { InheritanceView() }
                    FeatureLink("Enums", "enum class → native Swift enum") { EnumsView() }
                    FeatureLink("Sealed classes", "sealedType() → exhaustive switch") { SealedView() }
                    FeatureLink("Data & value classes", "copy, ==, Hashable, description") { DataClassesView() }
                }
                Section("Types") {
                    FeatureLink("Types & nullability", "Int32, unsigned, Char, optionals, Unit, Nothing") { TypesView() }
                    FeatureLink("Collections", "List, Set, Map, ranges → Swift types") { CollectionsView() }
                    FeatureLink("Generics", "erased type parameters, Swift values as Any") { GenericsView() }
                    FeatureLink("Generic wrappers", "ScreenState<T> → non-generic ProfileState") { GenericWrappersView() }
                    FeatureLink("Closures", "function types ↔ Swift closures") { ClosuresView() }
                    FeatureLink("Exceptions", "@Throws → throws, catching Kotlin exceptions") { ExceptionsView() }
                }
                Section("Concurrency") {
                    FeatureLink("Coroutines", "suspend → async throws, cancellation") { CoroutinesView() }
                    FeatureLink("Flows", "Flow, StateFlow → typed AsyncSequence") { FlowsView() }
                    FeatureLink("Implementing in Swift", "a Kotlin interface with Flow and suspend, in Swift") { SwiftImplementationView() }
                }
                Section("Modules") {
                    FeatureLink("Modules", "one Swift module per exported Kotlin module") { ModulesView() }
                    FeatureLink("Platform code", "iosMain and expect/actual") { PlatformView() }
                    FeatureLink("Hiding a dependency", "Koin leaked into the API, hidden with HIDDEN") { HiddenDependencyView() }
                }
            }
            .navigationTitle("Swift Export")
        }
    }
}

#Preview {
    FeatureCatalog()
}
