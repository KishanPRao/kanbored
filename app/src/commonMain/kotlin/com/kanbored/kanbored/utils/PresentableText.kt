package com.kanbored.kanbored.utils

import androidx.compose.runtime.Composable
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.getString
import org.jetbrains.compose.resources.stringResource

sealed interface PresentableText {
    data class DynamicString(val value: String) : PresentableText

    data class DynamicResource(
        val resId: StringResource,
        val args: List<Any> = emptyList(),
    ) : PresentableText

    @Composable
    fun asString(): String {
        return when (this) {
            is DynamicString -> value
            is DynamicResource -> stringResource(resId, *args.toTypedArray())
        }
    }

    // Completely avoid this!
    suspend fun asStringSuspend(): String {
        return when (this) {
            is DynamicString -> value
//            is DynamicResource -> context.getString(resId, *args.toTypedArray())
            is DynamicResource -> getString(resId)
        }
    }
}