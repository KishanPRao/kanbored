package com.kanbored.kanbored.screen

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Archive
import androidx.compose.material.icons.filled.Unarchive
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
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.ui.theme.LocalColors
import com.kanbored.kanbored.utils.ConnectionStatusStrip
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.PromptDialog
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.add_new_project
import kanbored.app.generated.resources.enter_name_new_project
import kanbored.app.generated.resources.projects
import kanbored.app.generated.resources.server_unreachable
import kanbored.app.generated.resources.settings
import kanbored.app.generated.resources.topbar_add_project
import kanbored.app.generated.resources.topbar_show_archived
import kotlinx.coroutines.flow.collectLatest
import org.jetbrains.compose.resources.stringResource

@Composable
fun HomeScreen(
    topBarVM: TopBarViewModel,
    kanbanVM: KanbanViewModel,
    onProjectOpened: (KanbanProject) -> Unit,
    onSettingsOpened: () -> Unit,
    modifier: Modifier = Modifier
) {
    var showArchived by rememberSaveable { mutableStateOf(false) }
    var showNewProjectDialog by rememberSaveable { mutableStateOf(false) }
    val title = stringResource(Res.string.projects)
    val tint = LocalColors.current.showArchived
    LaunchedEffect(showArchived) {
        println("show archived update")
        topBarVM.updateAll(
            title = title,
            showBackButton = false,
            topbarActions = listOf(
                TopBarAction(
                    icon = Icons.Filled.Add,
                    contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_project),
                    onClick = {
                        Logger.i("Add project")
                        showNewProjectDialog = true
                    }
                ),
                // TODO: Or find a different, more useful operation
                TopBarAction(
                    icon = if (showArchived) Icons.Filled.Unarchive else Icons.Filled.Archive,
                    contentDescription = PresentableText.DynamicResource(Res.string.topbar_show_archived),
                    tint = if (showArchived) tint else null,
                    onClick = {
                        Logger.i("Show archived: $showArchived")
                        showArchived = !showArchived
                        kanbanVM.showArchivedProjects(showArchived)
                    }
                ),
            ),
            dropdownItems = listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.settings)) {
                    Logger.i("Settings")
                    onSettingsOpened()
                },
            )
        )
    }
    if (showNewProjectDialog) {
        PromptDialog(
            title = PresentableText.DynamicResource(Res.string.add_new_project),
            hint = stringResource(Res.string.enter_name_new_project),
            showTextField = true,
            onClickOk = { text ->
                showNewProjectDialog = false
                println("Add new project: $text")
                kanbanVM.createProject(text)
            },
            onClickCancel = {
                showNewProjectDialog = false
            }
        )
    }
    var isRefreshing by rememberSaveable { mutableStateOf(false) }
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
                kanbanVM.refreshProjects()
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

//@Preview
//@Composable
//fun HomeScreenPreview() {
//    AppTheme(darkTheme = false) {
//        HomeScreen()
//    }
//}