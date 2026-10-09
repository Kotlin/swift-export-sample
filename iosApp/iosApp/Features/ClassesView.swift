import SwiftUI
import Shared

struct ClassesView: View {
    var body: some View {
        let rectangle = Rectangle(width: 3, height: 4)
        let corner = Corner(x: 1, y: 2)
        let fromCorners = rectangleFrom(origin: corner, opposite: Rectangle.Corner(x: 6, y: 8))

        FeatureScreen(
            title: "Classes",
            summary: "A Kotlin class is a final Swift class with an init per constructor. Nested classes stay nested, and the Kotlin typealias `Corner` is a Swift typealias for `Rectangle.Corner`."
        ) {
            DemoRow("Rectangle(width: 3, height: 4).area()", rectangle.area())
            DemoRow("Corner(x: 1, y: 2).y", corner.y)
            DemoRow("rectangleFrom(origin:opposite:).width", fromCorners.width)
        }
    }
}
