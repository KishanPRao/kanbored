package com.kanbored.kanbored.utils

import androidx.compose.runtime.Composable

abstract class DesktopContext
object EmptyDesktopContext : DesktopContext()

actual typealias PlatformContext = DesktopContext

@Composable
actual fun getContext(): PlatformContext = EmptyDesktopContext