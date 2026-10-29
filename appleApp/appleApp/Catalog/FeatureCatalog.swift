import SwiftUI

/// Entry point of the sample: one row per Swift Export feature.
/// Each feature has a Kotlin file in `shared/src/commonMain` and a screen in `Features/`
/// with the same name, e.g. `SealedTypes.kt` and `SealedTypesView.swift`.
struct FeatureCatalog: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Basics") {
                    FeatureLink("Basics", "top-level declarations, primitive types, vararg, @ObjCName") { BasicsView() }
                    FeatureLink("Extensions", "Kotlin extensions → Swift extensions") { ExtensionsView() }
                    FeatureLink("Operators", "operator fun → Swift operators and subscripts") { OperatorsView() }
                    FeatureLink("Annotations & docs", "KDoc, @Deprecated, @HiddenFromObjC, @RequiresOptIn") { AnnotationsView() }
                    FeatureLink("Context parameters", "context(log:) → an unlabeled leading parameter") { ContextParametersView() }
                }
                Section("Type hierarchy") {
                    FeatureLink("Classes", "nested and inner classes, open and abstract, objects, data and value classes") { ClassesView() }
                    FeatureLink("Interfaces", "protocols, Swift implementations of Kotlin interfaces") { InterfacesView() }
                    FeatureLink("Enums", "enum class → native Swift enum") { EnumsView() }
                    FeatureLink("Sealed types", "sealedType() → exhaustive switch") { SealedTypesView() }
                }
                Section("Types") {
                    FeatureLink("Collections", "List, Set, Map, ranges → Swift types") { CollectionsView() }
                    FeatureLink("Generics", "erased type parameters, Swift values as Any") { GenericsView() }
                    FeatureLink("Generic wrappers", "ScreenState<T> → non-generic ProfileState") { GenericWrappersView() }
                    FeatureLink("Function types", "function types ↔ Swift closures") { FunctionTypesView() }
                    FeatureLink("Exceptions", "@Throws → throws, catching Kotlin exceptions") { ExceptionsView() }
                }
                Section("Concurrency") {
                    FeatureLink("Coroutines", "suspend → async throws, flows, cancellation") { CoroutinesView() }
                    FeatureLink("Implementing in Swift", "a Kotlin interface with Flow and suspend, in Swift") { SwiftImplementationView() }
                }
                Section("Modules") {
                    FeatureLink("Modules", "one Swift module per exported Kotlin module") { ModulesView() }
                    FeatureLink("Platform code", "iosMain, macosMain, expect/actual") { PlatformView() }
                    FeatureLink("Hiding a dependency", "Koin and :module-d, hidden with HIDDEN") { HiddenDependencyView() }
                }
            }
            .navigationTitle("Swift Export")
        }
    }
}

#Preview {
    FeatureCatalog()
}
