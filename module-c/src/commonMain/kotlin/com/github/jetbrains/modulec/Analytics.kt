package com.github.jetbrains.modulec

class Event(val name: String, val properties: Map<String, String> = emptyMap())

class Analytics {
    private val events = mutableListOf<Event>()

    fun track(event: Event) {
        events += event
    }

    fun trackedEvents(): List<Event> = events.toList()
}

fun moduleCFunction(): Int = 7
