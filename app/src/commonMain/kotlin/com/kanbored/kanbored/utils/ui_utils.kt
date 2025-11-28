package com.kanbored.kanbored.utils

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.cancel
import kanbored.app.generated.resources.ok
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource

@Composable
fun KanbanIconButton(
    imageVector: ImageVector,
    contentDescription: StringResource,
    onClick: () -> Unit
) {
    IconButton(onClick = onClick) {
        Icon(
            imageVector = imageVector,
            contentDescription = stringResource(contentDescription)
        )
    }
}


@Composable
fun TextInputDialog(
    title: String,
    hint: String,
    onClickOk: (String) -> Unit,
    onClickCancel: () -> Unit,
) {
    var text by remember { mutableStateOf("") }
    var isError by remember { mutableStateOf(false) }
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
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(bottom = 20.dp),
                )
                OutlinedTextField(
                    modifier = Modifier.focusRequester(focusRequester),
                    value = text,
                    onValueChange = {
                        text = it
                        isError = false
                    },
                    label = { Text(hint) },
                    isError = isError,
                    singleLine = true,
                )
                Spacer(modifier = Modifier.height(20.dp))
                Row(
                    horizontalArrangement = Arrangement.End,
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    TextButton(onClick = {
                        if (text.isNotEmpty()) {
                            onClickOk(text)
                        } else {
                            isError = true
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

expect abstract class PlatformContext : Any {
//    expect fun getString(resId: StringResource, vararg args: Any): String
}

@Composable
expect fun getContext(): PlatformContext