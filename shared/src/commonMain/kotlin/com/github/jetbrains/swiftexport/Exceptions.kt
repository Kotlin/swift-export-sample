package com.github.jetbrains.swiftexport

// Exceptions
//
// Functions and constructors annotated with `@Throws` are `throws` in Swift. Kotlin exceptions
// conform to `Swift.Error`, so Swift can `catch let e as InsufficientFundsException`.
// An exception from a function without `@Throws` still terminates the app.

class InsufficientFundsException(val missing: Int) : Exception("Missing $missing")

class Wallet @Throws(IllegalArgumentException::class) constructor(balance: Int) {
    var balance: Int = balance
        private set

    init {
        require(balance >= 0) { "Balance can't be negative" }
    }

    @Throws(InsufficientFundsException::class)
    fun pay(amount: Int) {
        if (amount > balance) throw InsufficientFundsException(amount - balance)
        balance -= amount
    }
}
