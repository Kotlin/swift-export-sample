import SwiftUI
import Shared

struct DataClassesView: View {
    var body: some View {
        let point = Point(x: 1, y: 2)
        let moved = point.copy(x: 5, y: point.y)

        FeatureScreen(
            title: "Data & value classes",
            summary: "A data class is a final Swift class. Kotlin's equals, hashCode and toString back Swift's `==`, `Hashable` and `description`. `copy` requires every argument. A value class is a wrapper class."
        ) {
            Section("data class Point") {
                DemoRow("\"\\(point)\"", "\(point)")
                DemoRow("point.copy(x: 5, y: point.y)", "\(moved)")
                DemoRow("origin() == Point(x: 0, y: 0)", origin() == Point(x: 0, y: 0))
                DemoRow("Set([point, Point(x: 1, y: 2)]).count", Set([point, Point(x: 1, y: 2)]).count)
            }
            Section("value class UserId") {
                DemoRow("profileUrl(id: UserId(raw: \"42\"))", profileUrl(id: UserId(raw: "42")))
            }
        }
    }
}
