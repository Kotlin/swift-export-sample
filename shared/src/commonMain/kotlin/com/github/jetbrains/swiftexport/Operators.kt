package com.github.jetbrains.swiftexport

// Operators
//
// Kotlin operator functions become Swift operators: `+`, `*`, `<` (from `compareTo`), subscripts
// (from `get`) and `~=` (from `contains`), instead of method calls.

class Money(val cents: Long) : Comparable<Money> {
    operator fun plus(other: Money): Money = Money(cents + other.cents)

    operator fun times(factor: Int): Money = Money(cents * factor)

    override fun compareTo(other: Money): Int = cents.compareTo(other.cents)

    override fun toString(): String = "${cents / 100}.${(cents % 100).toString().padStart(2, '0')}"
}

class Playlist(private val songs: List<String>) {
    operator fun get(index: Int): String = songs[index]

    operator fun contains(song: String): Boolean = song in songs
}
