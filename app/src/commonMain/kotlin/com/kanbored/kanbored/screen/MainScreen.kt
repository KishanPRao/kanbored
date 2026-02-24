package com.kanbored.kanbored.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import co.touchlab.kermit.Logger
import co.touchlab.kermit.Severity
import co.touchlab.kermit.platformLogWriter
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.ui.utils.AppTopBar
import com.kanbored.kanbored.utils.DefaultSnackbar
import com.kanbored.kanbored.viewmodel.HomeViewModel
import com.kanbored.kanbored.viewmodel.MainViewModel
import com.kanbored.kanbored.viewmodel.ProjectViewModel
import com.kanbored.kanbored.viewmodel.TaskViewModel
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kotlinx.coroutines.flow.collectLatest

@Composable
fun MainScreen() {
    Logger.setLogWriters(platformLogWriter())
//    Logger.setMinSeverity(Severity.Info)
    Logger.setMinSeverity(Severity.Debug)
    AppTheme {
        val navController = rememberNavController()
        val mainVM: MainViewModel = hiltViewModel()
        val topBarVM: TopBarViewModel = hiltViewModel(
            // TODO: top bar vm?
//            navController.getBackStackEntry("app_graph")
        )
        val authConfig = mainVM.authConfig.collectAsState().value
        val isAuthenticated = authConfig.authenticated

        // TODO: loss of snackbar info if not saveable?
        val hostState = remember { SnackbarHostState() }
        var showLoading by rememberSaveable { mutableStateOf(false) }
        val onNavigateBack: () -> Unit = {
            topBarVM.popState()
            navController.popBackStack()
        }
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
                            DefaultSnackbar(snackbarData = snackbarData)
                        }
                    )
                })
            },
            topBar = {
                AppTopBar(
                    navController = navController,
                    topBarVM = topBarVM,
                    onNavigateBack = onNavigateBack
                )
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
                    val kanbanVM: HomeViewModel = hiltViewModel(kanbanGraphEntry)
                    HomeScreen(
                        topBarVM,
                        kanbanVM,
                        onProjectOpened = { project ->
                            navController.navigate(Route.Project(projectId = project.id))
                        }, onSettingsOpened = {
                            navController.navigate(Route.Settings)
                        }
                    )
                }
                composable<Route.Project> { entry ->
                    val kanbanGraphEntry = remember(entry) {
                        navController.getBackStackEntry(Route.Home)
                    }
                    val projectVM: ProjectViewModel = hiltViewModel(kanbanGraphEntry)
                    val args = entry.toRoute<Route.Project>()
                    ProjectScreen(topBarVM, projectVM, args.projectId, onTaskOpened = { task ->
                        navController.navigate(
                            Route.Task(
                                projectId = task.projectId,
                                columnId = task.columnId,
                                taskId = task.id,
                            )
                        )
                    }, onNavigateBack = onNavigateBack)
                }
                composable<Route.Task> { entry ->
                    val kanbanGraphEntry = remember(entry) {
                        navController.getBackStackEntry(Route.Home)
                    }
                    val taskVM: TaskViewModel = hiltViewModel(kanbanGraphEntry)
                    val args = entry.toRoute<Route.Task>()
                    TaskScreen(
                        topBarVM,
                        taskVM,
                        projectId = args.projectId,
                        columnId = args.columnId,
                        taskId = args.taskId,
                        onNavigateBack = onNavigateBack,
                    )
                }
                composable<Route.Settings> { entry ->
                    SettingsScreen(
                        topBarVM = topBarVM,
                    )
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