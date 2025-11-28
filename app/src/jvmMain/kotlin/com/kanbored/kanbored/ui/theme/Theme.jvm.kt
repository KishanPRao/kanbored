package com.kanbored.kanbored.ui.theme

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable


actual fun canEnableDynamicColor(): Boolean = false

@Composable
actual fun dynamicColorTheme(darkTheme: Boolean): ColorScheme {
    return if (darkTheme) darkColorScheme() else lightColorScheme()
}