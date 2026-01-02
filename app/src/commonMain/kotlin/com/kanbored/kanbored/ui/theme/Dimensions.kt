package com.kanbored.kanbored.ui.theme

import androidx.compose.runtime.compositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

data class Dimensions(
    val columnTaskWidth: Dp = 250.dp,
    val columnTaskHeight: Dp = 80.dp,
    val columnTaskPadding: Dp = 15.dp,
    val columnPadding: Dp = 12.dp,
    val columnItemsPadding: Dp = 8.dp,
//    val minTaskDescHeight: Dp = 70.dp,
)

val LocalDimensions = compositionLocalOf { Dimensions() }