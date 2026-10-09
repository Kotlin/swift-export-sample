package com.github.jetbrains.swiftexport

import platform.UIKit.UIDevice

actual fun platformName(): String = UIDevice.currentDevice.systemName
