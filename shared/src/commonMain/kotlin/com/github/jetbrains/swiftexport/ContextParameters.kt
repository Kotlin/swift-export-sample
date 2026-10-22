package com.github.jetbrains.swiftexport

class AuditLog {
    private val entries = mutableListOf<String>()

    fun record(entry: String) {
        entries += entry
    }

    fun entries(): List<String> = entries.toList()
}

// Context parameters become leading unlabeled Swift parameters: `placeOrder(log, item: "book")`
context(log: AuditLog)
fun placeOrder(item: String): String {
    log.record("Ordered $item")
    return "Order for $item placed"
}
