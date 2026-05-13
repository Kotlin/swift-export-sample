package com.github.jetbrains.swiftexport

import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch

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

    @OptIn(DelicateCoroutinesApi::class)
    fun runSuspendBlock(block: suspend () -> Unit) {
        GlobalScope.launch {
            block()
        }
    }
}