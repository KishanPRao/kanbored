package com.kanbored.kanbored.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.ExperimentalMaterial3Api
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
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.TopbarDropdownMenuItem
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.MainViewModel
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.navigate_back
import kanbored.app.generated.resources.topbar_more_options
import kotlinx.coroutines.flow.collectLatest

@Composable
fun MainScreen() {
    AppTheme {
        val navController = rememberNavController()
        val mainVM: MainViewModel = hiltViewModel()
        val topBarVM: TopBarViewModel = hiltViewModel(
            // TODO: top bar vm?
//            navController.getBackStackEntry("app_graph")
        )
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
            topBar = {
                AppTopBar(navController = navController, topBarVM = topBarVM)
            },
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
                                duration = SnackbarDuration.Indefinite,
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
                composable<Route.Login> {
                    LoginScreen(topBarVM)
                }
                composable<Route.Home> { entry ->
                    val kanbanGraphEntry = remember(entry) {
                        navController.getBackStackEntry(Route.Home)
                    }
                    val kanbanVM: KanbanViewModel = hiltViewModel(kanbanGraphEntry)
                    HomeScreen(topBarVM, kanbanVM, onProjectOpened = { project ->
                        navController.navigate(Route.Project(projectId = project.id))
                    })
                }
                composable<Route.Project> { entry ->
                    val kanbanGraphEntry = remember(entry) {
                        navController.getBackStackEntry(Route.Home)
                    }
                    val kanbanVM: KanbanViewModel = hiltViewModel(kanbanGraphEntry)
                    val args = entry.toRoute<Route.Project>()
                    ProjectScreen(topBarVM, kanbanVM, args.projectId)
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
    topBarVM: TopBarViewModel,
) {
    val topBarVMState = topBarVM.state.collectAsState()
    var expandedMenu by remember { mutableStateOf(false) }
    val topBarState = topBarVMState.value
    TopAppBar(
        title = { Text(topBarState.title) },
        navigationIcon = {
            if (topBarState.showBackButton) {
                KanbanIconButton(
                    Icons.AutoMirrored.Filled.ArrowBack,
                    Res.string.navigate_back,
                ) {
                    topBarVM.revertState()
                    navController.popBackStack()
                }
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