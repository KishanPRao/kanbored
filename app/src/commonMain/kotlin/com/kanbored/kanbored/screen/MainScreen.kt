package com.kanbored.kanbored.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.navigation.NavDestination
import androidx.navigation.NavDestination.Companion.hasRoute
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.utils.AppUiEvent
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.TextInputDialog
import com.kanbored.kanbored.viewmodel.MainViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.add_new_project
import kanbored.app.generated.resources.enter_name_new_project
import kanbored.app.generated.resources.login
import kanbored.app.generated.resources.navigate_back
import kanbored.app.generated.resources.projects
import kanbored.app.generated.resources.topbar_add_project
import kanbored.app.generated.resources.topbar_more_options
import kanbored.app.generated.resources.topbar_settings
import kanbored.app.generated.resources.topbar_show_archived
import kotlinx.coroutines.flow.collectLatest
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource

@Composable
fun MainScreen() {
    AppTheme {
        val navController = rememberNavController()
        val mainVM: MainViewModel = hiltViewModel()
        val authConfig = mainVM.authConfig.collectAsState().value
        val isAuthenticated = authConfig.authenticated

        val hostState = remember { SnackbarHostState() }
        var showLoading by remember { mutableStateOf(false) }
        Scaffold(
            snackbarHost = {
                SnackbarHost(hostState = hostState, snackbar = { snackbarData ->
                    val dismissState = rememberSwipeToDismissBoxState()
                    LaunchedEffect(dismissState.currentValue) {
                        if (dismissState.currentValue != SwipeToDismissBoxValue.Settled) {
                            snackbarData.dismiss()
                        }
                    }
                    SwipeToDismissBox(
                        state = dismissState,
                        backgroundContent = {},
                        content = {
                            Snackbar(snackbarData = snackbarData)
                        }
                    )
                })
            },
            topBar = { AppTopBar(navController = navController) },
            modifier = Modifier.fillMaxSize(),
        ) { innerPadding ->
            LaunchedEffect(Unit) {
                mainVM.appEventBus.events.collectLatest { event ->
                    when (event) {
                        is AppUiEvent.ShowMessage -> {
                            hostState.showSnackbar(
                                message = event.message.asStringSuspend(),
                                duration = SnackbarDuration.Short,
                            )
                        }

                        is AppUiEvent.ShowError -> {
                            hostState.showSnackbar(
                                message = event.message.asStringSuspend(),
                                withDismissAction = true,
                                duration = SnackbarDuration.Long,
                            )
                        }

                        AppUiEvent.HideGlobalLoading -> showLoading = false
                        AppUiEvent.ShowGlobalLoading -> showLoading = true
                    }
                }
            }
            NavHost(
                navController = navController,
                startDestination = when {
                    isAuthenticated -> Route.Home
                    else -> Route.Login
                },
                modifier = Modifier.padding(innerPadding)
            ) {
                composable<Route.Home> {
                    HomeScreen()
                }
                composable<Route.Login> {
                    LoginScreen()
                }
            }

            if (showLoading) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(Color.Black.copy(alpha = 0.3f))
                        .pointerInput(Unit) {
                            // Blocks all touches
                            detectTapGestures { }
                        }
                ) {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center)
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun AppTopBar(
    navController: NavHostController,
    modifier: Modifier = Modifier,
) {
    val backStackEntry by navController.currentBackStackEntryAsState()
    val destination = backStackEntry?.destination
    TopAppBar(
        title = { TopbarTitle(destination) },
        modifier = modifier,
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer,
            titleContentColor = MaterialTheme.colorScheme.onPrimaryContainer,
        ),
        navigationIcon = { TopbarNavigationIcon(navController, destination) },
        actions = { TopbarIcons(destination) }
    )
}

@Composable
private fun TopbarTitle(destination: NavDestination?) {
    Text(
        text = when {
            destination?.hasRoute<Route.Home>() == true -> {
                stringResource(Res.string.projects)
            }

            destination?.hasRoute<Route.Login>() == true -> {
                stringResource(Res.string.login)
            }

            else -> {
                ""
            }
        }
    )
}

@Composable
private fun TopbarIcons(destination: NavDestination?) {
    when {
        destination?.hasRoute<Route.Home>() == true -> {
            var expandedMenu by remember { mutableStateOf(false) }
            var showDialog by remember { mutableStateOf(false) }
            Row {
                KanbanIconButton(Icons.Filled.Add, Res.string.topbar_add_project) {
                    println("Add project")
                    showDialog = true
                }
                KanbanIconButton(Icons.Filled.MoreVert, Res.string.topbar_more_options) {
                    expandedMenu = true
                }
                DropdownMenu(
                    expanded = expandedMenu,
                    onDismissRequest = { expandedMenu = false }
                ) {
                    TopbarDropdownMenuItem(Res.string.topbar_show_archived) {
                        expandedMenu = false
                    }
                    TopbarDropdownMenuItem(Res.string.topbar_settings) {
                        expandedMenu = false
                    }
                }
                if (showDialog) {
                    TextInputDialog(
                        title = stringResource(Res.string.add_new_project),
                        hint = stringResource(Res.string.enter_name_new_project),
                        onClickOk = { text ->
                            showDialog = false
                            println("Add new project: $text")
                        },
                        onClickCancel = {
                            showDialog = false
                        }
                    )
                }
            }
        }

        else -> {}
    }
}

@Composable
private fun TopbarDropdownMenuItem(textRes: StringResource, onClick: () -> Unit) {
    DropdownMenuItem(
        text = { Text(stringResource(textRes)) },
        onClick = onClick
    )
}

@Composable
private fun TopbarNavigationIcon(
    navController: NavHostController,
    destination: NavDestination?
) {
    if (showNavigationIcon(destination)) {
        IconButton(onClick = {
            navController.popBackStack()
        }) {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = stringResource(Res.string.navigate_back)
            )
        }
    }
}

private fun showNavigationIcon(destination: NavDestination?): Boolean {
    return when {
//            destination?.hasRoute<Route.Home>() == true -> {
//                true
//            }

        else -> {
            false
        }
    }
}