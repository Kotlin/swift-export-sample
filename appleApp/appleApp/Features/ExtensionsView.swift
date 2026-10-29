import SwiftUI
import Shared

struct ExtensionsView: View {
    var body: some View {
        let point = Point(x: 1, y: 2)
        let account = Account(owner: "Ada")

        FeatureScreen(
            title: "Extensions",
            summary: "Extension functions and properties from the root package become Swift extensions, so they read the same as in Kotlin. An extension on a nullable receiver is an extension on the Swift optional, and extension properties can have setters."
        ) {
            DemoRow(#""hello".shout()"#, "hello".shout())
            DemoRow(#""Hi".repeated(times: 3)"#, "Hi".repeated(times: 3))
            DemoRow(#""Swift Export is neat".wordCount"#, "Swift Export is neat".wordCount)
            DemoRow("Int32(21).isEven()", Int32(21).isEven())
            DemoRow("Point(x: 1, y: 2).distanceTo(other: Point(x: 4, y: 6))", point.distanceTo(other: Point(x: 4, y: 6)))
            DemoRow("(nil as String?).orDefault()", (nil as String?).orDefault())
            DemoRow(#"account.formattedBalance = "rich" — the extension var's setter writes nickname"#, formattedBalanceDemo(account))
        }
    }

    private func formattedBalanceDemo(_ account: Account) -> String {
        account.deposit(amount: 100)
        account.formattedBalance = "rich"
        return "\(account.formattedBalance); nickname: \(account.nickname)"
    }
}
