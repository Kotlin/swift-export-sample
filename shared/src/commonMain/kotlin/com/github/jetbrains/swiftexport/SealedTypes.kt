package com.github.jetbrains.swiftexport

// Sealed hierarchies get a generated `<Name>_SealedType` Swift enum,
// so Swift can `switch` over `sealedType()` exhaustively.
sealed class LoadingState {
    object Loading : LoadingState()
    class Success(val data: String) : LoadingState()
    class Error(val message: String) : LoadingState()
}

fun loadingStates(): List<LoadingState> = listOf(
    LoadingState.Loading,
    LoadingState.Success("Kotlin ❤️ Swift"),
    LoadingState.Error("Network is unavailable"),
)

sealed interface Command {
    data class Move(val steps: Int) : Command
    data object Stop : Command
}

fun execute(command: Command): String = when (command) {
    is Command.Move -> "Moving ${command.steps} steps"
    Command.Stop -> "Stopped"
}
