package com.kanbored.kanbored.ui.theme

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

actual fun canEnableDynamicColor(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.S

@RequiresApi(Build.VERSION_CODES.S)
@Composable
actual fun dynamicColorTheme(darkTheme: Boolean): ColorScheme {
    val context = LocalContext.current
    return if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
}