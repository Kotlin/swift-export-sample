import SwiftUI
import Shared
// Members of stdlib types, such as the StringBuilder constructor, live in KotlinStdlib
import KotlinStdlib

struct CollectionsView: View {
    var body: some View {
        let lengths = wordLengths(words: ["kotlin", "swift"])
        let builder = ExportedKotlinPackages.kotlin.text.StringBuilder()

        FeatureScreen(
            title: "Collections",
            summary: "Read-only `List`, `Set` and `Map` are native Swift `Array`, `Set` and `Dictionary`, copied across the boundary. `IntRange` is `ClosedRange<Int32>`, and `ByteArray` is an opaque wrapper with no Swift `Data` conversion. A mutable Kotlin collection is exported as an opaque `any kotlin.collections.MutableList`."
        ) {
            DemoRow(#"wordLengths(words: ["kotlin", "swift"])"#, lengths.sorted { $0.key < $1.key }.map { "\($0.key): \($0.value)" }.joined(separator: ", "))
            DemoRow(#"uniqueWords(text: "a b A c").sorted()"#, uniqueWords(text: "a b A c").sorted().joined(separator: ", "))
            DemoRow("digits()", "\(digits())")
            DemoRow("evensIn(range: 1...10)", evensIn(range: 1...10).map(String.init).joined(separator: ", "))
            DemoRow("fibonacci(count: 8)", fibonacci(count: 8).map(String.init).joined(separator: ", "))
            DemoRow("nestedLists()", "\(nestedLists())")
            DemoRow(#"buildGreeting(builder: StringBuilder(), name: "Swift")"#, buildGreeting(builder: builder, name: "Swift"))
            DemoRow(#"checksum(bytes: bytesOf(text: "Kotlin"))"#, checksum(bytes: bytesOf(text: "Kotlin")))
            DemoRow("mutableNames()", "returns `any kotlin.collections.MutableList`, an opaque wrapper")
        }
    }
}
