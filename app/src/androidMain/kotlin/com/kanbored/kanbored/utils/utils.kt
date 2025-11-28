package com.kanbored.kanbored.utils

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

actual typealias PlatformContext = Context

@Composable
actual fun getContext(): PlatformContext = LocalContext.current