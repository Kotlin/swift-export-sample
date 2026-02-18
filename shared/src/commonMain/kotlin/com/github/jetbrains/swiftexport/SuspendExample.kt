package com.github.jetbrains.swiftexport

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class User(val name: String, val age: Int)

class UsersViewModel {
    val users: Flow<User> = flow {
        for (user in loadUsers()) {
            emit(user)
            delay(1000)
        }
    }

    @Throws(Exception::class)
    suspend fun loadUsers(): List<User> {
        delay(2000)
        return listOf(User("John Doe", 30), User("Jane Doe", 25))
    }
}