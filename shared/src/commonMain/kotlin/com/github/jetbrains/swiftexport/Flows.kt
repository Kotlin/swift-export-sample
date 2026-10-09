package com.github.jetbrains.swiftexport

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

// Flows
//
// `Flow<User>` keeps its element type in Swift. `asAsyncSequence()` turns it into a throwing
// `AsyncSequence`, so `for try await user in flow.asAsyncSequence()` yields `User` without casts.
// Leaving the loop cancels the collection.

class UserFeed(private val repository: UserRepository) {
    val users: Flow<User> = flow {
        for (user in repository.loadUsers()) {
            emit(user)
            delay(300)
        }
    }
}
