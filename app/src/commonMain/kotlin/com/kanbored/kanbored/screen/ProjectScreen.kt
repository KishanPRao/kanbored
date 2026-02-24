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
import androidx.compose.foundation.layout.requiredWidth
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.PlaylistAdd
import androidx.compose.material.icons.automirrored.filled.ViewList
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.Done
import androidx.compose.material.icons.filled.GridView
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
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
import androidx.compose.ui.focus.FocusState
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.ui.theme.LocalDimensions
import com.kanbored.kanbored.utils.ConnectionStatusStrip
import com.kanbored.kanbored.utils.EditMode
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.PromptDialog
import com.kanbored.kanbored.utils.emptyColumn
import com.kanbored.kanbored.utils.emptyProject
import com.kanbored.kanbored.utils.emptyTask
import com.kanbored.kanbored.viewmodel.ProjectViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.add_new_column
import kanbored.app.generated.resources.add_task
import kanbored.app.generated.resources.archive
import kanbored.app.generated.resources.cancel
import kanbored.app.generated.resources.delete
import kanbored.app.generated.resources.done
import kanbored.app.generated.resources.enter_name_new_column
import kanbored.app.generated.resources.enter_name_update_project
import kanbored.app.generated.resources.new_task_name
import kanbored.app.generated.resources.rename
import kanbored.app.generated.resources.server_unreachable
import kanbored.app.generated.resources.topbar_add_column
import kanbored.app.generated.resources.topbar_change_view
import kanbored.app.generated.resources.topbar_hide_archived
import kanbored.app.generated.resources.topbar_show_archived
import kanbored.app.generated.resources.unarchive
import kotlinx.coroutines.flow.collectLatest
import org.jetbrains.compose.resources.stringResource

@Composable
fun ProjectScreen(
    topBarVM: TopBarViewModel,
    projectVM: ProjectViewModel,
    projectId: Int,
    onTaskOpened: (KanbanTask) -> Unit,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier,
) {
    var showAddColDialog by rememberSaveable { mutableStateOf(false) }
    var showRenameDialog by rememberSaveable { mutableStateOf(false) }
    var showDeleteDialog by rememberSaveable { mutableStateOf(false) }
    // TODO: observe the object instead? If project screen open, then project updated from api worker?
    val project by projectVM.getProject(projectId = projectId)
        .collectAsStateWithLifecycle(emptyProject)
    var isGridView by rememberSaveable { mutableStateOf(false) }
    var isArchived by rememberSaveable { mutableStateOf(false) }
    Logger.i("Project name: ${project.name}")
    LaunchedEffect(project) {
        // TODO: This gets re-called after opening and exiting task, causing full refresh; why?
        if (project.isValid()) {
            // Load all tasks initially
            projectVM.refreshColumnsAndTasks(
                projectId = project.id,
                isArchived = false,
                showRefresh = false,
            )
            projectVM.refreshColumnsAndTasks(
                projectId = project.id,
                isArchived = true,
                showRefresh = false,
            )
        }
        topBarVM.pushState()
        topBarVM.updateTitle(project.name)
        topBarVM.showBackButton(true)
    }
    val archivedString =
        if (isArchived) Res.string.topbar_hide_archived else Res.string.topbar_show_archived
    val archiveString =
        if (project.isActive) Res.string.archive else Res.string.unarchive
    topBarVM.setDropdownItems(
        listOf(
            TopBarDropdownItem(PresentableText.DynamicResource(Res.string.rename)) {
                Logger.d("Rename")
                showRenameDialog = true
            },
            TopBarDropdownItem(PresentableText.DynamicResource(archivedString)) {
                isArchived = !isArchived
                Logger.d("Toggle archived: $isArchived")
            },
            TopBarDropdownItem(PresentableText.DynamicResource(archiveString)) {
                Logger.d("Archive, currently: ${project.isActive}")
                if (project.isActive) {
                    projectVM.disableProject(project)
                } else {
                    projectVM.enableProject(project)
                }
            },
            TopBarDropdownItem(PresentableText.DynamicResource(Res.string.delete)) {
                Logger.d("Delete")
                showDeleteDialog = true
            },
        )
    )
    topBarVM.setActions(
        listOf(
            TopBarAction(
                icon = Icons.AutoMirrored.Filled.PlaylistAdd,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_column),
                onClick = {
                    Logger.d("Add column")
                    showAddColDialog = true
                }
            ),
            TopBarAction(
                icon = if (isGridView) Icons.AutoMirrored.Filled.ViewList else Icons.Filled.GridView,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_change_view),
                onClick = {
                    // TODO: show grid view or list
                    Logger.d("Change view")
                    isGridView = !isGridView
                }
            ),
        )
    )
    if (!project.isValid()) return
    if (showAddColDialog) {
        PromptDialog(
            title = PresentableText.DynamicResource(Res.string.add_new_column),
            hint = stringResource(Res.string.enter_name_new_column),
            showTextField = true,
            onClickOk = { text ->
                showAddColDialog = false
                Logger.d("Add new column: $text")
                projectVM.createColumn(projectId, text)
            },
            onClickCancel = {
                showAddColDialog = false
            }
        )
    }
    if (showDeleteDialog) {
        PromptDialog(
            title = PresentableText.DynamicString(
                "${stringResource(Res.string.delete)} ${project.name}?"
            ),
            showTextField = false,
            onClickOk = {
                showDeleteDialog = false
                Logger.d("Delete project: $project")
                projectVM.deleteProject(project)
                onNavigateBack()
            },
            onClickCancel = {
                showDeleteDialog = false
            }
        )
    }
    if (showRenameDialog) {
        PromptDialog(
            title = PresentableText.DynamicString(
                "${stringResource(Res.string.rename)} ${project.name}?"
            ),
            hint = stringResource(Res.string.enter_name_update_project),
            showTextField = true,
            initText = project.name,
            onClickOk = { text ->
                showRenameDialog = false
                Logger.d("Rename project: $project")
                projectVM.updateProject(project.copy(name = text))
                topBarVM.popState() // The project gets updated, and we pushState again
            },
            onClickCancel = {
                showRenameDialog = false
            }
        )
    }

    var isRefreshing by rememberSaveable { mutableStateOf(false) }
    val isApiReachable by projectVM.isApiReachable.collectAsState()
    LaunchedEffect(Unit) {
        projectVM.uiEventFlow.collectLatest { event ->
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
            onRefresh = { projectVM.refreshColumnsAndTasks(project.id, isArchived) },
            modifier = Modifier.fillMaxSize(),
        ) {
            ColumnList(
                projectId = project.id,
                isArchived = isArchived,
                topBarVM = topBarVM,
                projectVM = projectVM,
                onTaskOpened = onTaskOpened
            )
        }
    }
}

@Composable
fun ColumnList(
    projectId: Int,
    isArchived: Boolean,
    topBarVM: TopBarViewModel,
    projectVM: ProjectViewModel,
    onTaskOpened: (KanbanTask) -> Unit,
) {
    val columns by projectVM.getColumns(projectId, isArchived)
        .collectAsStateWithLifecycle(emptyList())
//    Logger.d("columns: $columns")
    LazyRow {
        items(items = columns, key = { it.id }) { column ->
            val tasks by projectVM.getTasks(projectId, column.id, isArchived)
                .collectAsStateWithLifecycle(emptyList())
            println("column tasks: $tasks")
            var editMode by rememberSaveable { mutableStateOf(EditMode.Idle) }
            var newTaskName by rememberSaveable { mutableStateOf("") }
            var isValidTaskName by rememberSaveable { mutableStateOf(true) }
            Logger.v("edit mode: $editMode")
            if (editMode == EditMode.Cancel || editMode == EditMode.Idle) {
                val focusManager = LocalFocusManager.current
                focusManager.clearFocus()
                isValidTaskName = true
                newTaskName = ""
            }
            val addTaskStr = stringResource(Res.string.add_task)
            LaunchedEffect(editMode) {
                if (editMode == EditMode.Start) {
                    topBarVM.pushState()
                    topBarVM.updateTitle(addTaskStr)
                    topBarVM.setActions(
                        listOf(
                            TopBarAction(
                                icon = Icons.Filled.Cancel,
                                contentDescription = PresentableText.DynamicResource(Res.string.cancel),
                                onClick = {
                                    Logger.d("Cancel")
                                    editMode = EditMode.Cancel
                                    topBarVM.popState()
                                    newTaskName = ""
                                }
                            ),
                            TopBarAction(
                                icon = Icons.Filled.Done,
                                contentDescription = PresentableText.DynamicResource(Res.string.done),
                                onClick = {
                                    if (newTaskName.isEmpty()) {
                                        isValidTaskName = false
                                    } else {
                                        topBarVM.popState()
                                        Logger.i("Add $newTaskName task into $column")
                                        projectVM.createTask(projectId, column.id, newTaskName)
                                        editMode = EditMode.Idle
                                    }
                                }
                            ),
                        )
                    )
                }
            }
            ColumnView(
                column,
                tasks,
                newTaskName,
                isValidTaskName,
                onTaskOpened,
                onNewTaskNameFocusChanged = { state ->
                    if (state.isFocused) {
                        editMode = EditMode.Start
                    } else {
                        Logger.w("focus lost! undo?")
                    }
                },
                onNewTaskNameUpdated = {
                    Logger.v("onNewTaskNameUpdated: $newTaskName")
                    newTaskName = it
                })
        }
    }
}

@Composable
fun ColumnView(
    column: KanbanColumn,
    tasks: List<KanbanTask>,
    newTaskName: String,
    isValidTaskName: Boolean,
    onTaskOpened: (KanbanTask) -> Unit,
    onNewTaskNameFocusChanged: (FocusState) -> Unit,
    onNewTaskNameUpdated: (String) -> Unit,
) {
    val dimensions = LocalDimensions.current
//    Logger.d("tasks: $tasks")
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
                .padding(dimensions.columnItemsHorizPadding)
                .clickable {
                }) {
            Text(column.title)
        }
        LazyColumn(
            modifier = Modifier
                .padding(dimensions.columnItemsHorizPadding)
                .weight(1f)
                .requiredWidth(dimensions.columnTaskWidth),
            verticalArrangement = Arrangement.spacedBy(dimensions.columnItemsVertPadding)
        ) {
            items(items = tasks, key = { it.id }) { task ->
                TaskView(task, onTaskOpened)
            }
        }
        OutlinedTextField(
            modifier = Modifier
                .onFocusChanged(onNewTaskNameFocusChanged)
                .padding(dimensions.columnItemsHorizPadding)
                .widthIn(max = dimensions.columnTaskWidth),
            value = newTaskName,
            label = { Text(stringResource(Res.string.add_task)) },
            singleLine = true,
            isError = !isValidTaskName,
            placeholder = { Text(stringResource(Res.string.new_task_name)) },
            onValueChange = onNewTaskNameUpdated
        )
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

@Preview
@Composable
fun ColumnViewPreview() {
    var id = 0
    val tasks = listOf(
        emptyTask.copy(id = ++id, title = "Task 1"),
        emptyTask.copy(id = ++id, title = "Task 2"),
        emptyTask.copy(id = ++id, title = "Task 3"),
        emptyTask.copy(id = ++id, title = "Task 4"),
        emptyTask.copy(id = ++id, title = "Task 5"),
        emptyTask.copy(id = ++id, title = "Task 6"),
        emptyTask.copy(id = ++id, title = "Task 7"),
        emptyTask.copy(id = ++id, title = "Task 8"),
        emptyTask.copy(id = ++id, title = "Task 9"),
        emptyTask.copy(id = ++id, title = "Task 10"),
        emptyTask.copy(id = ++id, title = "Task 11"),
        emptyTask.copy(id = ++id, title = "Task 12"),
        emptyTask.copy(id = ++id, title = "Task 13"),
    )
    AppTheme(darkTheme = false) {
        ColumnView(
            column = emptyColumn.copy(title = "Todo"),
            tasks = tasks,
            newTaskName = "",
            onNewTaskNameUpdated = {},
            onNewTaskNameFocusChanged = {},
            onTaskOpened = {},
            isValidTaskName = true,
        )
    }
}