package com.kanbored.kanbored.screen

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.PlaylistAdd
import androidx.compose.material.icons.automirrored.filled.ViewList
import androidx.compose.material.icons.filled.GridView
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
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.ui.theme.LocalDimensions
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.TextInputDialog
import com.kanbored.kanbored.utils.emptyTask
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.add_new_column
import kanbored.app.generated.resources.enter_name_new_column
import kanbored.app.generated.resources.server_unreachable
import kanbored.app.generated.resources.topbar_add_column
import kanbored.app.generated.resources.topbar_change_view
import kanbored.app.generated.resources.topbar_settings
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource

@Composable
fun ProjectScreen(
    topBarVM: TopBarViewModel,
    kanbanVM: KanbanViewModel,
    projectId: Int,
    onTaskOpened: (KanbanTask) -> Unit,
    modifier: Modifier = Modifier
) {
    var showDialog by remember { mutableStateOf(false) }
    val project = kanbanVM.getProject(projectId = projectId)
    var isGridView by remember { mutableStateOf(false) }
    var isArchived by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) {
        topBarVM.saveState()
        topBarVM.updateTitle(project.name)
        topBarVM.showBackButton(true)
        topBarVM.setDropdownItems(
            listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.topbar_settings)) {
                },
            )
        )
    }
    topBarVM.setActions(
        listOf(
            TopBarAction(
                icon = Icons.AutoMirrored.Filled.PlaylistAdd,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_column),
                onClick = {
                    println("Add column")
                    showDialog = true
                }
            ),
            TopBarAction(
                icon = if (isGridView) Icons.AutoMirrored.Filled.ViewList else Icons.Filled.GridView,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_change_view),
                onClick = {
                    // TODO: show grid view or list
                    println("Change view")
                    isGridView = !isGridView
                }
            ),
        )
    )
    if (showDialog) {
        TextInputDialog(
            title = stringResource(Res.string.add_new_column),
            hint = stringResource(Res.string.enter_name_new_column),
            onClickOk = { text ->
                showDialog = false
                println("Add new column: $text")
                kanbanVM.createColumn(projectId, text)
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
    Column(modifier = modifier.fillMaxSize()) {
        ConnectionStatusStrip(
            stringResource(Res.string.server_unreachable),
            !isApiReachable,
        )
        PullToRefreshBox(
            isRefreshing = isRefreshing,
            onRefresh = {
                kanbanVM.viewModelScope.launch {
                    kanbanVM.refreshColumnsAndTasks(projectId, isArchived)
                }
            },
            modifier = Modifier.fillMaxSize(),
        ) { ColumnList(projectId, kanbanVM, onTaskOpened) }
    }
}

@Composable
fun ColumnList(projectId: Int, kanbanVM: KanbanViewModel, onTaskOpened: (KanbanTask) -> Unit) {
    val columns by kanbanVM.getColumns(projectId).collectAsStateWithLifecycle(emptyList())
    println("columns: $columns")
    LazyRow {
        items(items = columns, key = { it.id }) { column ->
            ColumnView(projectId, column, kanbanVM, onTaskOpened)
        }
    }
}

@Composable
fun ColumnView(
    projectId: Int,
    column: KanbanColumn,
    kanbanVM: KanbanViewModel,
    onTaskOpened: (KanbanTask) -> Unit
) {
    val dimensions = LocalDimensions.current
    val tasks by kanbanVM.getTasks(projectId, column.id).collectAsStateWithLifecycle(emptyList())
    println("tasks: $tasks")
    Card(
        modifier = Modifier
            .fillMaxHeight()
            .padding(start = dimensions.columnPadding, top = dimensions.columnPadding),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface,
        )
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp)
                .clickable {
                }) {
            Text(column.title)
        }
        LazyColumn(verticalArrangement = Arrangement.spacedBy(dimensions.columnItemsPadding)) {
            items(items = tasks, key = { it.id }) { task ->
                TaskView(task, onTaskOpened)
            }
        }
    }
}

@Composable
fun TaskView(task: KanbanTask, onTaskOpened: (KanbanTask) -> Unit) {
    val dimensions = LocalDimensions.current
    Card(
        modifier = Modifier
            .width(dimensions.columnTaskWidth)
            .height(dimensions.columnTaskHeight),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant,
        ), onClick = {
            onTaskOpened(task)
        }
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(dimensions.columnTaskPadding),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = task.title,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Preview
@Composable
fun TaskViewPreview() {
    AppTheme(darkTheme = false) {
        TaskView(
            emptyTask.copy(title = "Elden Ring"),
            { }
        )
    }
}