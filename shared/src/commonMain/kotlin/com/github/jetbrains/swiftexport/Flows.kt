package com.github.jetbrains.swiftexport

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flow

// Flows
//
// `Flow<User>` keeps its element type in Swift. `asAsyncSequence()` turns it into a throwing
// `AsyncSequence`, so `for try await user in flow.asAsyncSequence()` yields `User` without casts.
// Leaving the loop cancels the collection.
// `StateFlow<T>` also has a typed `value`; a `MutableStateFlow<T>` can be set from Swift.

class UserFeed(private val repository: UserRepository) {
    val users: Flow<User> = flow {
        for (user in repository.loadUsers()) {
            emit(user)
            delay(300)
        }
    }
}

class ClickCounter {
    private val _clicks = MutableStateFlow(0)
    val clicks: StateFlow<Int> = _clicks.asStateFlow()

    val label: MutableStateFlow<String> = MutableStateFlow("Clicks")

    fun click() {
        _clicks.value += 1
    }
}
