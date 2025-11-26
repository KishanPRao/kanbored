package com.kanbored.kanbored.screen

import android.util.Patterns
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Password
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.kanbored.kanbored.R
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.viewmodel.KanbanViewModel

@Composable
fun LoginScreen(
    kanbanVM: KanbanViewModel,
) {
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.fillMaxSize()
    ) {
        val spacing = 30.dp
        var url by rememberSaveable { mutableStateOf("http://192.168.0.50:6080") }
        var userName by rememberSaveable { mutableStateOf("admin") }
        var password by rememberSaveable { mutableStateOf("admin") }
        var isValidUrl by rememberSaveable { mutableStateOf(true) }
        var isValidUserName by rememberSaveable { mutableStateOf(true) }
        var isValidPassword by rememberSaveable { mutableStateOf(true) }
        FormField(
            value = url,
            onValueChange = { url = it },
            supportingText = stringResource(R.string.login_url),
            Icons.Default.Cloud,
            placeholder = stringResource(R.string.login_url_hint),
        ) { isValidUrl }
        Spacer(modifier = Modifier.height(spacing))
        FormField(
            value = userName,
            onValueChange = { userName = it },
            supportingText = stringResource(R.string.login_username),
            Icons.Default.Person,
            placeholder = stringResource(R.string.login_username_hint),
        ) { isValidUserName }
        Spacer(modifier = Modifier.height(spacing))
        FormField(
            value = password,
            onValueChange = { password = it },
            supportingText = stringResource(R.string.login_password),
            icon = Icons.Default.Password,
            placeholder = stringResource(R.string.login_password_hint),
            isPassword = true,
        ) { isValidPassword }
        Spacer(modifier = Modifier.height(spacing))

        TextButton(
            modifier = Modifier
                .background(color = MaterialTheme.colorScheme.primaryContainer),
            shape = RoundedCornerShape(0.dp),
            elevation = ButtonDefaults.elevatedButtonElevation(10.dp),
            onClick = {
                println("LOGIN: $url")
                isValidUrl = validateUrl(url)
                isValidUserName = validateUsername(userName)
                isValidPassword = validatePassword(password)
                if (isValidUrl && isValidUserName && isValidPassword) {
                    kanbanVM.login(
                        hostUrl = url,
                        userName = userName,
                        password = password,
                    )
                } else {
                    kanbanVM.showUiMessage(
                        PresentableText.StringResource(R.string.login_err_invalid_input)
                    )
                }
            }) { Text(stringResource(R.string.login_button)) }
    }
}

private fun validateUrl(url: String): Boolean {
    if (url.matches(Regex("^https?://localhost(:\\d+)?(/.*)?$"))) {
        return true
    }
    return Patterns.WEB_URL.matcher(url).matches()
}

private fun validateUsername(username: String): Boolean = username.isNotEmpty()

private fun validatePassword(password: String): Boolean = password.isNotEmpty()

@Composable
private fun FormField(
    value: String,
    onValueChange: (String) -> Unit,
    supportingText: String,
    icon: ImageVector,
    placeholder: String,
    modifier: Modifier = Modifier,
    isPassword: Boolean = false,
    isValidInput: () -> Boolean,
) {
    var passwordVisible by rememberSaveable { mutableStateOf(false) }
    OutlinedTextField(
        value = value,
        onValueChange = onValueChange,
        modifier = modifier.width(300.dp),
        label = { Text(text = supportingText, color = MaterialTheme.colorScheme.primary) },
        leadingIcon = {
            Icon(
                icon,
                contentDescription = supportingText,
                tint = MaterialTheme.colorScheme.primary,
            )
        },
        visualTransformation = if (!isPassword || passwordVisible) {
            VisualTransformation.None
        } else {
            PasswordVisualTransformation()
        },
        keyboardOptions = if (isPassword) {
            KeyboardOptions(
                keyboardType = KeyboardType.Password
            )
        } else {
            KeyboardOptions.Default
        },
        trailingIcon =
            if (isPassword) {
                {
                    val image = if (passwordVisible) {
                        Icons.Filled.Visibility
                    } else {
                        Icons.Filled.VisibilityOff
                    }
                    val description = if (passwordVisible) {
                        stringResource(R.string.hide_password)
                    } else {
                        stringResource(R.string.show_password)
                    }

                    IconButton(onClick = { passwordVisible = !passwordVisible }) {
                        Icon(imageVector = image, contentDescription = description)
                    }
                }
            } else {
                null
            },
        isError = !isValidInput(),
        singleLine = true,
        placeholder = { Text(placeholder) }
    )
}

@Preview()
@Composable
fun LoginPreviewDark() {
    val context = LocalContext.current
    AppTheme(darkTheme = false) {
        // TODO: avoid plugging actual repo/db into preview
        val kanbanVM = viewModel<KanbanViewModel> { KanbanViewModel(context) }
        LoginScreen(kanbanVM)
    }
}