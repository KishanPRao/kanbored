package com.kanbored.kanbored.screen

import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.app_name
import org.jetbrains.compose.resources.stringResource

fun main() = application {
    Window(
        onCloseRequest = ::exitApplication,
        title = stringResource(Res.string.app_name),
    ) {
        MainScreen()
    }
}