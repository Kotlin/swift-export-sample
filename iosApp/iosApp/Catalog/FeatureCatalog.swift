import SwiftUI

/// Entry point of the sample: one row per Swift Export feature.
/// Each feature has a Kotlin file in `shared/src/commonMain` and a screen in `Features/`
/// with the same name, e.g. `Sealed.kt` and `SealedView.swift`.
struct FeatureCatalog: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Basics") {
                    FeatureLink("Classes", "final classes, nested classes, typealiases") { ClassesView() }
                    FeatureLink("Functions", "top-level functions, overloads") { FunctionsView() }
                    FeatureLink("Extensions", "Kotlin extensions → Swift extensions") { ExtensionsView() }
                    FeatureLink("Enums", "enum class → native Swift enum") { EnumsView() }
                }
                Section("Types") {
                    FeatureLink("Generics", "erased type parameters, Swift values as Any") { GenericsView() }
                    FeatureLink("Closures", "function types ↔ Swift closures") { ClosuresView() }
                }
                Section("Concurrency") {
                    FeatureLink("Coroutines", "suspend → async throws, suspend lambdas") { CoroutinesView() }
                    FeatureLink("Flows", "Flow<T> → typed AsyncSequence") { FlowsView() }
                }
                Section("Modules") {
                    FeatureLink("Modules", "one Swift module per exported Kotlin module") { ModulesView() }
                    FeatureLink("Platform code", "iosMain and expect/actual") { PlatformView() }
                }
            }
            .navigationTitle("Swift Export")
        }
    }
}

#Preview {
    FeatureCatalog()
}
