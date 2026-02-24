package com.kanbored.kanbored.screen

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.settings
import kanbored.app.generated.resources.settings_logout
import kanbored.app.generated.resources.settings_theme
import org.jetbrains.compose.resources.stringResource

@Composable
fun SettingsScreen(
    topBarVM: TopBarViewModel,
    modifier: Modifier = Modifier,
) {
    val title = stringResource(Res.string.settings)
    LaunchedEffect(Unit) {
        topBarVM.updateAll(
            title = title,
            showBackButton = true,
            topbarActions = emptyList(),
            dropdownItems = emptyList(),
        )
    }
    SettingsContent(
        onChangeTheme = {},
        onLogout = {},
        modifier = modifier
    )
}

@Composable
fun SettingsContent(
    onChangeTheme: () -> Unit,
    onLogout: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier = modifier) {
        // TODO: drop down?
        Text(
            modifier = Modifier
                .fillMaxWidth()
                .clickable(enabled = true, onClick = {
                })
                .padding(10.dp),
            text = stringResource(Res.string.settings_theme),
        )
        Text(
            modifier = Modifier
                .fillMaxWidth()
                .clickable(enabled = true, onClick = {
                })
                .padding(10.dp),
            text = stringResource(Res.string.settings_logout),
        )
    }
}

