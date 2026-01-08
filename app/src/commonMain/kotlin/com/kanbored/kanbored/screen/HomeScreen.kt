package com.kanbored.kanbored.screen

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Archive
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.PromptDialog
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.add_new_project
import kanbored.app.generated.resources.enter_name_new_project
import kanbored.app.generated.resources.online
import kanbored.app.generated.resources.projects
import kanbored.app.generated.resources.server_unreachable
import kanbored.app.generated.resources.settings
import kanbored.app.generated.resources.topbar_add_project
import kanbored.app.generated.resources.topbar_show_archived
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource

@Composable
fun HomeScreen(
    topBarVM: TopBarViewModel,
    kanbanVM: KanbanViewModel,
    onProjectOpened: (KanbanProject) -> Unit,
    modifier: Modifier = Modifier
) {
    var showDialog by remember { mutableStateOf(false) }
    val title = stringResource(Res.string.projects)
    LaunchedEffect(Unit) {
        topBarVM.updateTitle(title)
        topBarVM.showBackButton(false)
        topBarVM.setActions(
            listOf(
                TopBarAction(
                    icon = Icons.Filled.Add,
                    contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_project),
                    onClick = {
                        println("Add project")
                        showDialog = true
                    }
                ),
                // TODO: Or find a different, more useful operation
                TopBarAction(
                    icon = Icons.Filled.Archive,
                    contentDescription = PresentableText.DynamicResource(Res.string.topbar_show_archived),
                    onClick = {
                        println("Show archived")
                    }
                ),
            ))
        topBarVM.setDropdownItems(
            listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.settings)) {
                    println("Settings")
                },
            )
        )
    }
    if (showDialog) {
        PromptDialog(
            title = PresentableText.DynamicResource(Res.string.add_new_project),
            hint = stringResource(Res.string.enter_name_new_project),
            showTextField = true,
            onClickOk = { text ->
                showDialog = false
                println("Add new project: $text")
                kanbanVM.createProject(text)
            },
            onClickCancel = {
                showDialog = false
            }
        )
    }
    var isRefreshing by remember { mutableStateOf(false) }
    val isApiReachable by kanbanVM.isApiReachable.collectAsState()
    LaunchedEffect(Unit) {
        kanbanVM.uiEventFlow.collectLatest { event ->
            when (event) {
                UiEvent.HideLoading -> isRefreshing = false
                UiEvent.ShowLoading -> isRefreshing = true
                else -> {}
            }
        }
    }
    Logger.d("isApiReachable: $isApiReachable")
    Column(modifier = modifier.fillMaxSize()) {
        ConnectionStatusStrip(
            stringResource(Res.string.server_unreachable),
            !isApiReachable,
        )
        PullToRefreshBox(
            isRefreshing = isRefreshing,
            onRefresh = {
                kanbanVM.viewModelScope.launch {
                    kanbanVM.refreshProjects()
                }
            },
            modifier = Modifier.fillMaxSize(),
        ) { ProjectGrid(kanbanVM, onProjectOpened) }
    }
}

@Composable
fun ProjectGrid(kanbanVM: KanbanViewModel, onProjectOpened: (KanbanProject) -> Unit) {
    val projects by kanbanVM.projects.collectAsStateWithLifecycle()
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(4.dp, 12.dp, 4.dp, 4.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        items(projects) { project ->
//            println("project: ${project.name}")
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f)
                    .clickable {
                        println("open project: ${project.name}")
                        onProjectOpened(project)
                    },
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant,
                )
            ) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(project.name)
                }
            }
        }
    }
}

@Composable
fun ConnectionStatusStrip(
    errorText: String,
    isVisible: Boolean,
) {
    var showStrip by remember { mutableStateOf(false) }
    var isOnline by remember { mutableStateOf(true) }
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

//@Preview
//@Composable
//fun HomeScreenPreview() {
//    AppTheme(darkTheme = false) {
//        HomeScreen()
//    }
//}