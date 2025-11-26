package com.kanbored.kanbored.screen

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.rememberSwipeToDismissBoxState
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
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.utils.UiEvent
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import kotlinx.coroutines.flow.collectLatest

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            AppTheme {
                val context = LocalContext.current
                val kanbanVM =
                    viewModel<KanbanViewModel> { KanbanViewModel(context = context) }
                val navController = rememberNavController()
                val userSession = kanbanVM.authenticatedSession.collectAsState().value
                println("user session: $userSession")
                val isAuthenticated = userSession?.authenticated

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
                    modifier = Modifier.fillMaxSize(),
                ) { innerPadding ->
                    val context = LocalContext.current  // TODO: bad idea?
                    LaunchedEffect(Unit) {
                        kanbanVM.uiEventFlow.collectLatest { event ->
                            when (event) {
                                is UiEvent.ShowMessage -> {
                                    hostState.showSnackbar(
                                        message = event.message.asString(context = context),
                                    )
                                }

                                UiEvent.HideLoading -> showLoading = false
                                UiEvent.ShowLoading -> showLoading = true
                            }
                        }
                    }
                    NavHost(
                        navController = navController,
                        startDestination = when {
                            isAuthenticated == null -> Route.Empty  // Not loaded yet
                            isAuthenticated -> Route.Home
                            else -> Route.Login
                        },
                        modifier = Modifier.padding(innerPadding)
                    ) {
                        composable<Route.Empty> {
                            Box(modifier = Modifier.fillMaxSize())
                        }
                        composable<Route.Home> {
                            HomeScreen(
                                kanbanVM = kanbanVM,
                            )
                        }
                        composable<Route.Login> {
                            LoginScreen(
                                kanbanVM = kanbanVM,
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
    }
}