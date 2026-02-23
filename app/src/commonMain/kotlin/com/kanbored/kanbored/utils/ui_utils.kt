package com.kanbored.kanbored.utils

import android.content.res.Configuration.UI_MODE_NIGHT_NO
import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarData
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.kanbored.kanbored.ui.theme.AppTheme
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.cancel
import kanbored.app.generated.resources.ok
import kanbored.app.generated.resources.online
import kotlinx.coroutines.delay
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource

// TODO: if not re-used, move into Project Screen
enum class EditMode {
    Idle,
    Start,
    Cancel,
}

@Composable
fun KanbanIconButton(
    imageVector: ImageVector,
    contentDescription: StringResource,
    modifier: Modifier = Modifier,
    tint: Color = LocalContentColor.current,
    onClick: () -> Unit
) {
    KanbanIconButton(
        imageVector = imageVector,
        contentDescription = stringResource(contentDescription),
        tint = tint,
        modifier = modifier,
        onClick = onClick
    )
}

@Composable
fun KanbanIconButton(
    imageVector: ImageVector,
    contentDescription: String,
    modifier: Modifier = Modifier,
    tint: Color? = null,
    onClick: () -> Unit
) {
    IconButton(modifier = modifier, onClick = onClick) {
        Icon(
            imageVector = imageVector,
            contentDescription = contentDescription,
            tint = tint ?: LocalContentColor.current,
        )
    }
}


@Composable
fun TopbarDropdownMenuItem(text: String, onClick: () -> Unit) {
    DropdownMenuItem(
        text = { Text(text) },
        onClick = onClick
    )
}

// TODO: move to ui_utils
@Composable
fun ConnectionStatusStrip(
    errorText: String,
    isVisible: Boolean,
) {
    var showStrip by rememberSaveable { mutableStateOf(false) }
    var isOnline by rememberSaveable { mutableStateOf(true) }
    var text = errorText
    var bgColor = MaterialTheme.colorScheme.onError
    var textColor = MaterialTheme.colorScheme.error
    if (isOnline) {
        // TODO: green for online?
        bgColor = MaterialTheme.colorScheme.onPrimary
        textColor = MaterialTheme.colorScheme.primary
        text = stringResource(Res.string.online)
    }

    LaunchedEffect(isVisible, errorText) {
        if (!isVisible && showStrip) {
            isOnline = true
            delay(1000)
            showStrip = false
        } else if (isVisible) {
            isOnline = false
            showStrip = true
        }
    }

    AnimatedVisibility(
        visible = showStrip,
        enter = slideInVertically() + fadeIn(),
        exit = slideOutVertically() + fadeOut(
            animationSpec = tween(300)
        )
    ) {
        AnimatedContent(
            targetState = text,
            transitionSpec = {
                fadeIn(animationSpec = tween(500)) togetherWith
                        fadeOut(animationSpec = tween(500))
            },
            label = "conn_strip_anim"
        ) { text ->
            Text(
                text = text,
                modifier = Modifier
                    .fillMaxWidth()
                    .background(bgColor)
                    .padding(5.dp),
                color = textColor,
                textAlign = TextAlign.Center,
                maxLines = 1,
            )
        }
    }
}

@Composable
fun PromptDialog(
    title: PresentableText,
    showTextField: Boolean,
    hint: String? = null,
    initText: String = "",
    onClickOk: (String) -> Unit,
    onClickCancel: () -> Unit,
) {
    var text by rememberSaveable { mutableStateOf(initText) }
    var isError by rememberSaveable { mutableStateOf(false) }
    val focusRequester = remember { FocusRequester() }
    Dialog(
        onDismissRequest = {},
        properties = DialogProperties(dismissOnClickOutside = false, dismissOnBackPress = false)
    ) {
        Surface(
            shape = MaterialTheme.shapes.medium,
            color = MaterialTheme.colorScheme.background,
            tonalElevation = 8.dp
        ) {
            Column(
                modifier = Modifier
                    .padding(25.dp)
                    .width(IntrinsicSize.Min)
            ) {
                Text(
                    text = title.asString(),
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(bottom = 20.dp),
                )
                if (showTextField) {
                    OutlinedTextField(
                        modifier = Modifier.focusRequester(focusRequester),
                        value = text,
                        onValueChange = {
                            text = it
                            isError = false
                        },
                        label = { hint?.let { Text(it) } },
                        isError = isError,
                        singleLine = true,
                    )
                }
                Spacer(modifier = Modifier.height(20.dp))
                Row(
                    horizontalArrangement = Arrangement.End,
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    TextButton(onClick = {
                        if (showTextField) {
                            if (text.isNotEmpty()) {
                                onClickOk(text)
                            } else {
                                isError = true
                            }
                        } else {
                            onClickOk("")
                        }
                    }) { Text(stringResource(Res.string.ok)) }
                    Spacer(modifier = Modifier.height(10.dp))
                    TextButton(onClick = onClickCancel) { Text(stringResource(Res.string.cancel)) }
                }
            }
        }
    }
    LaunchedEffect(Unit) {
        focusRequester.requestFocus()
    }
}

//expect abstract class PlatformContext : Any {
////    expect fun getString(resId: StringResource, vararg args: Any): String
//}
//
//@Composable
//expect fun getContext(): PlatformContext

@Composable
fun DefaultSnackbar(snackbarData: SnackbarData) {
    Snackbar(
        snackbarData = snackbarData,
        containerColor = MaterialTheme.colorScheme.primaryContainer,
        contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
        dismissActionContentColor = MaterialTheme.colorScheme.onPrimaryContainer,
    )
}

@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_NO)
@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun SnackbarPreview() {
    AppTheme {
        val hostState = remember { SnackbarHostState() }
        SnackbarHost(hostState = hostState, snackbar = { snackbarData ->
            DefaultSnackbar(snackbarData)
        })
        LaunchedEffect(Unit) {
            hostState.showSnackbar(
                message = "Something went wrong",
                withDismissAction = true,
                duration = SnackbarDuration.Indefinite,
            )
        }
    }
}