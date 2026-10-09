package com.github.jetbrains.swiftexport

import platform.Foundation.NSProcessInfo

actual fun osName(): String = NSProcessInfo.processInfo.operatingSystemVersionString
