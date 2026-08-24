package com.github.jetbrains.swiftexport

fun iosBar(): Int = 125

interface CryptoProvider {
    fun hashMD5(input: String): String
}

fun processHash(provider: CryptoProvider, input: String): String = provider.hashMD5(input)

open class SwiftBase