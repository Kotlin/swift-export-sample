import SwiftUI
import Shared

struct ExceptionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Exceptions",
            summary: "`@Throws` functions and constructors are `throws` in Swift, and Kotlin exceptions conform to `Swift.Error`. Without `@Throws` an exception terminates the app."
        ) {
            DemoRow("try Wallet(balance: 10).pay(amount: 4)", attempt { let w = try Wallet(balance: 10); try w.pay(amount: 4); return "balance \(w.balance)" })
            DemoRow("try Wallet(balance: 10).pay(amount: 25)", attempt { try Wallet(balance: 10).pay(amount: 25); return "paid" })
            DemoRow("try Wallet(balance: -1)", attempt { _ = try Wallet(balance: -1); return "created" })
        }
    }

    private func attempt(_ body: () throws -> String) -> String {
        do {
            return try body()
        } catch let error as InsufficientFundsException {
            return "InsufficientFundsException, missing \(error.missing)"
        } catch {
            return "\(type(of: error)): \(error)"
        }
    }
}
