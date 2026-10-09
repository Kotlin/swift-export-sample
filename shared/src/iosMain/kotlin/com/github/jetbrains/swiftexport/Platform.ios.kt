package com.github.jetbrains.swiftexport

import platform.UIKit.UIDevice

actual fun osName(): String = UIDevice.currentDevice.systemName
