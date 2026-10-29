import SwiftUI
import Shared
// Members inherited from stdlib classes, such as Throwable.message, live in KotlinStdlib
import KotlinStdlib

struct ExceptionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Exceptions",
            summary: "`@Throws` functions and constructors are `throws` in Swift, and Kotlin exceptions conform to `Swift.Error`. Without `@Throws` an exception terminates the app."
        ) {
            Section("@Throws with a custom exception") {
                DemoRow("try Wallet(balance: 10).pay(amount: 4)", attempt { let wallet = try Wallet(balance: 10); try wallet.pay(amount: 4); return "balance \(wallet.balance)" })
                DemoRow("try Wallet(balance: 10).pay(amount: 25)", attempt { try Wallet(balance: 10).pay(amount: 25); return "paid" })
                DemoRow("try Wallet(balance: -1)", attempt { _ = try Wallet(balance: -1); return "created" })
            }
            Section("@Throws with a specific exception type") {
                DemoRow(#"try parseAge(input: "42")"#, attempt { String(try parseAge(input: "42")) })
                DemoRow(#"try parseAge(input: "forty two")"#, attempt { String(try parseAge(input: "forty two")) })
            }
            Section("Throwing constructors") {
                DemoRow("try PositiveNumber(value: 5)", attempt { String(try PositiveNumber(value: 5).value) })
                DemoRow("try PositiveNumber(value: -1)", attempt { _ = try PositiveNumber(value: -1); return "created" })
            }
        }
    }

    private func attempt(_ body: () throws -> String) -> String {
        do {
            return try body()
        } catch let error as InsufficientFundsException {
            return "InsufficientFundsException, missing \(error.missing)"
        } catch let error as ValidationException {
            return "ValidationException: \(error.message ?? "unknown error")"
        } catch {
            return "\(type(of: error)): \(error)"
        }
    }
}
