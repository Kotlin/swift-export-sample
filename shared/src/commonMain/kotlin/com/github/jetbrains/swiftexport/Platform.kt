package com.github.jetbrains.swiftexport

// Platform-specific code
//
// An `expect` declaration in `commonMain` becomes a regular declaration in the exported API.
// Each platform build links the matching `actual` implementation from `iosMain` or `macosMain`.

expect fun osName(): String
