package com.github.jetbrains.swiftexport

import platform.UIKit.UIDevice

// Platform-specific source sets add API only to the matching Swift platforms
fun iosBar(): Int = 125

// Platform types (UIKit, Foundation) are used as is in Swift
fun currentDevice(): UIDevice = UIDevice.currentDevice

fun platformName(): String = "${UIDevice.currentDevice.systemName} ${UIDevice.currentDevice.systemVersion}"
