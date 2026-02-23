package com.kanbored.kanbored.ui.utils

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.TopbarDropdownMenuItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.navigate_back
import kanbored.app.generated.resources.topbar_more_options


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppTopBar(
    navController: NavHostController,
    topBarVM: TopBarViewModel,
    onNavigateBack: () -> Unit,
) {
    val topBarState by topBarVM.state.collectAsState()
    var expandedMenu by rememberSaveable { mutableStateOf(false) }
    TopAppBar(
        title = { Text(topBarState.title) },
        navigationIcon = {
            if (topBarState.showBackButton) {
                KanbanIconButton(
                    Icons.AutoMirrored.Filled.ArrowBack,
                    Res.string.navigate_back,
                    onClick = onNavigateBack
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer,
            titleContentColor = MaterialTheme.colorScheme.onPrimaryContainer,
        ),
        actions = {
            topBarState.actions.forEach { action ->
                KanbanIconButton(
                    action.icon,
                    action.contentDescription.asString(),
                    tint = action.tint,
                    onClick = action.onClick,
                )
            }
            if (topBarState.dropdownItems.isNotEmpty()) {
                KanbanIconButton(
                    imageVector = Icons.Default.MoreVert,
                    contentDescription = Res.string.topbar_more_options,
                    onClick = { expandedMenu = true },
                )
            }
        }
    )
    if (topBarState.dropdownItems.isNotEmpty()) {
        Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.TopEnd) {
            DropdownMenu(
                offset = DpOffset(x = (-4).dp, y = 0.dp),
                expanded = expandedMenu,
                onDismissRequest = { expandedMenu = false }
            ) {
                topBarState.dropdownItems.forEach { action ->
                    TopbarDropdownMenuItem(action.contentDescription.asString()) {
                        expandedMenu = false
                        action.onClick()
                    }
                }
            }
        }
    }
}