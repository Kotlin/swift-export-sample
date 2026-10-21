package com.github.jetbrains.swiftexport

import platform.Foundation.NSProcessInfo

// Platform-specific source sets add API only to the matching Swift platforms
fun platformName(): String = "macOS ${NSProcessInfo.processInfo.operatingSystemVersionString}"
