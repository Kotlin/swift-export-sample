import SwiftUI
import Shared

struct CollectionsView: View {
    var body: some View {
        let lengths = wordLengths(words: ["kotlin", "swift"])

        FeatureScreen(
            title: "Collections",
            summary: "Read-only `List`, `Set` and `Map` are native Swift `Array`, `Set` and `Dictionary`, copied across the boundary. `IntRange` is `ClosedRange<Int32>`."
        ) {
            DemoRow("wordLengths(words: [\"kotlin\", \"swift\"])", lengths.sorted { $0.key < $1.key }.map { "\($0.key): \($0.value)" }.joined(separator: ", "))
            DemoRow("uniqueWords(text: \"a b A c\").sorted()", uniqueWords(text: "a b A c").sorted().joined(separator: ", "))
            DemoRow("digits()", "\(digits())")
            DemoRow("evensIn(range: 1...10)", evensIn(range: 1...10).map(String.init).joined(separator: ", "))
        }
    }
}
