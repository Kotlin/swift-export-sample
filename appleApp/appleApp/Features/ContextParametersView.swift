import SwiftUI
import Shared

struct ContextParametersView: View {
    var body: some View {
        let log = AuditLog()

        FeatureScreen(
            title: "Context parameters",
            summary: "A Kotlin context parameter is exported like a regular parameter: `context(log: AuditLog) fun placeOrder(item: String)` becomes `func placeOrder(_ context: AuditLog, item: String)`. Swift passes the log, and the Kotlin function records into it."
        ) {
            DemoRow(#"placeOrder(log, item: "book")"#, placeOrder(log, item: "book"))
            DemoRow("log.entries()", log.entries().joined(separator: "; "))
        }
    }
}
