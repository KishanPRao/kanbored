package com.kanbored.kanbored.screen

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Password
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.kanbored.kanbored.ui.theme.KanboredTheme
import com.kanbored.kanbored.ui.theme.Purple80

@Composable
fun LoginScreen() {
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.fillMaxSize()
    ) {
        val url = ""
        val username = ""
        val password = ""
        FormField(
            url,
            {},
            "Kanboard URL",
            Icons.Default.Cloud,
            "https://kanboard_url.com"
        )
        Spacer(modifier = Modifier.height(40.dp))
        FormField(
            username,
            {},
            "Username",
            Icons.Default.Person,
            "admin"
        )
        Spacer(modifier = Modifier.height(40.dp))
        FormField(
            password,
            {},
            "Password",
            Icons.Default.Password,
            "hunter2"
        )
        Spacer(modifier = Modifier.height(40.dp))
        LoginButton()
    }
}

@Composable
private fun LoginButton() {
    TextButton(onClick = {
        println("Click")
    }) { Text("LOGIN") }
}

@Composable
private fun FormField(
    value: String,
    onValueChange: (String) -> Unit,
    supportingText: String,
    icon: ImageVector,
    placeholder: String,
    modifier: Modifier = Modifier
) {
    TextField(
        value = value,
        onValueChange = onValueChange,
        modifier = modifier,
        label = { Text(text = supportingText, color = Purple80) },
        leadingIcon = { Icon(icon, contentDescription = supportingText, tint = Purple80) },
        singleLine = true,
        placeholder = { Text(placeholder) }
    )
}

@Preview()
@Composable
fun LoginPreviewDark() {
    KanboredTheme(darkTheme = false) {
        LoginScreen()
    }
}