package com.kanbored.kanbored.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.PlaylistAdd
import androidx.compose.material.icons.filled.Archive
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.EditNote
import androidx.compose.material.icons.filled.Unarchive
import androidx.compose.material.icons.rounded.DragHandle
import androidx.compose.material3.Checkbox
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanSubtaskFinished
import com.kanbored.kanbored.model.KanbanSubtaskTodo
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.ui.theme.LocalDimensions
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.PromptDialog
import com.kanbored.kanbored.utils.emptyTask
import com.kanbored.kanbored.viewmodel.TaskViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import com.mikepenz.markdown.m3.Markdown
import com.mikepenz.markdown.m3.markdownColor
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.archive
import kanbored.app.generated.resources.comments
import kanbored.app.generated.resources.delete
import kanbored.app.generated.resources.edit
import kanbored.app.generated.resources.empty_task_description
import kanbored.app.generated.resources.enter_name_update_task
import kanbored.app.generated.resources.rename
import kanbored.app.generated.resources.reorder
import kanbored.app.generated.resources.subtasks
import kanbored.app.generated.resources.topbar_add_checklist
import kanbored.app.generated.resources.unarchive
import org.jetbrains.compose.resources.stringResource
import sh.calvin.reorderable.ReorderableItem
import sh.calvin.reorderable.rememberReorderableLazyListState

@Composable
fun TaskScreen(
    topBarVM: TopBarViewModel,
    taskVM: TaskViewModel,
    projectId: Int,
    columnId: Int,
    taskId: Int,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    var isArchived by rememberSaveable { mutableStateOf(false) }
    val task: KanbanTask by taskVM.getTask(
        projectId = projectId,
        columnId = columnId,
        taskId = taskId
    ).collectAsStateWithLifecycle(emptyTask)
    Logger.i("task: $task")
    val subtasks: List<KanbanSubtask> by taskVM.getSubtasks(taskId)
        .collectAsStateWithLifecycle(emptyList())
    val comments: List<KanbanComment> by taskVM.getComments(taskId)
        .collectAsStateWithLifecycle(emptyList())
    var rawMarkdown by remember { mutableStateOf("") }
    var showRenameDialog by rememberSaveable { mutableStateOf(false) }
    var showDeleteDialog by rememberSaveable { mutableStateOf(false) }
    LaunchedEffect(task) {
        if (task.isValid()) {
            taskVM.refreshSubtasksAndComments(task.id)
        }
        topBarVM.pushState()
        topBarVM.updateTitle(task.title)
        topBarVM.showBackButton(true)
        topBarVM.setDropdownItems(
            listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.rename)) {
                    Logger.i("Rename")
                    showRenameDialog = true
                },
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.delete)) {
                    Logger.i("Delete")
                    showDeleteDialog = true
                },
            )
        )
        rawMarkdown = task.description.trimIndent()
    }
    topBarVM.setActions(
        listOf(
            TopBarAction(
                icon = Icons.AutoMirrored.Filled.PlaylistAdd,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_checklist),
                onClick = {
                    println("Add a new checklist")
                }
            ),
            TopBarAction(
                icon = if (isArchived) Icons.Filled.Unarchive else Icons.Filled.Archive,
                contentDescription = PresentableText.DynamicResource(
                    if (isArchived) Res.string.unarchive else Res.string.archive
                ),
                onClick = {
                    println("Un/Archive task")
                }
            ),
        ))
    if (showRenameDialog) {
        PromptDialog(
            title = PresentableText.DynamicString(
                "${stringResource(Res.string.rename)} ${task.title}?"
            ),
            hint = stringResource(Res.string.enter_name_update_task),
            showTextField = true,
            initText = task.title,
            onClickOk = { text ->
                showRenameDialog = false
                Logger.d("Rename task: $task")
                taskVM.updateTask(task.copy(title = text))
                topBarVM.popState() // The task gets updated, and we pushState again
            },
            onClickCancel = {
                showRenameDialog = false
            }
        )
    }
    if (showDeleteDialog) {
        PromptDialog(
            title = PresentableText.DynamicString(
                "${stringResource(Res.string.delete)} ${task.title}?"
            ),
            showTextField = false,
            onClickOk = {
                showDeleteDialog = false
                Logger.d("Delete task: $task")
                taskVM.deleteTask(task)
                onNavigateBack()
            },
            onClickCancel = {
                showDeleteDialog = false
            }
        )
    }
    if (!task.isValid()) return
    // TODO: Use single LazyColumn, avoid nesting, item/items(..) multiple times instead
    Column(modifier = modifier) {
        TaskDescription(rawMarkdown)
        TaskSubtasks(subtasks)
        TaskComments(comments)
    }
}

@Composable
fun TaskDescription(description: String, modifier: Modifier = Modifier) {
    // TODO: is this the best way?
    var rawMarkdown = description
    var isRawText by rememberSaveable { mutableStateOf(false) }
    LocalDimensions.current
    Box(modifier = modifier) {
        if (isRawText) {
            RawMarkdownEditor(
                markdown = rawMarkdown,
                onMarkdownChange = { rawMarkdown = it },
                modifier = Modifier
                    .fillMaxWidth()
//                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(16.dp)
                    .background(MaterialTheme.colorScheme.surfaceContainer)
            )
        } else {
            Markdown(
                content = rawMarkdown.ifEmpty { stringResource(Res.string.empty_task_description) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(6.dp)
                    .background(MaterialTheme.colorScheme.surfaceContainer)
                    // TODO: need more spacing instead
//                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(10.dp)
                    .verticalScroll(rememberScrollState()),
                colors = markdownColor(text = if (rawMarkdown.isEmpty()) MaterialTheme.colorScheme.onPrimaryContainer else MaterialTheme.colorScheme.onSurface)
            )
        }
        KanbanIconButton(
            if (isRawText) Icons.Filled.EditNote else Icons.Filled.Edit,
            Res.string.edit,
            tint = if (isRawText) Color.Yellow else LocalContentColor.current,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(5.dp),
        ) {
            isRawText = !isRawText
        }
    }
}

@Composable
fun TaskSubtasks(kanbanSubtasks: List<KanbanSubtask>, modifier: Modifier = Modifier) {
    val hapticFeedback = LocalHapticFeedback.current
    // TODO: best way?
    var subtasks by remember(kanbanSubtasks) { mutableStateOf(kanbanSubtasks.sortedBy { it.position }) }
    val lazyListState = rememberLazyListState()
    val reorderableLazyListState = rememberReorderableLazyListState(lazyListState) { from, to ->
        subtasks = subtasks.toMutableList().apply {
            add(to.index, removeAt(from.index))
        }
        println("re-order subtask: $from => $to")
        hapticFeedback.performHapticFeedback(HapticFeedbackType.SegmentFrequentTick)
    }

    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.background)
            .padding(5.dp)
    ) {
        Text(
            text = stringResource(Res.string.subtasks),
            fontWeight = FontWeight.Bold,
        )
        LazyColumn(modifier = modifier.padding(8.dp), state = lazyListState) {
            items(subtasks, key = { it.id }) { subtask ->
                ReorderableItem(reorderableLazyListState, key = subtask.id) { isDragging ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Checkbox(subtask.status == KanbanSubtaskFinished, { checked ->
                            val status =
                                if (subtask.status == KanbanSubtaskFinished) KanbanSubtaskTodo else KanbanSubtaskFinished
                            println("Update status: $status")
                            val updatedSubtask = subtask.copy(status = status)
                            subtasks = subtasks.toMutableList().apply {
                                val idx = indexOf(subtask)
                                removeAt(idx)
                                add(idx, updatedSubtask)
                            }
                            // TODO: actually update; avoid just UI update!
                        })
                        Text(subtask.title, modifier = Modifier.weight(1f))
                        IconButton(
                            modifier = Modifier.draggableHandle(
                                onDragStarted = {
                                    hapticFeedback.performHapticFeedback(HapticFeedbackType.GestureThresholdActivate)
                                },
                                onDragStopped = {
                                    hapticFeedback.performHapticFeedback(HapticFeedbackType.GestureEnd)
                                    // TODO: actually update positions
                                },
                            ),
                            onClick = {},
                        ) {
                            Icon(
                                Icons.Rounded.DragHandle,
                                contentDescription = stringResource(Res.string.reorder)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun TaskComments(comments: List<KanbanComment>, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.background)
            .padding(5.dp)
    ) {
        Text(
            text = stringResource(Res.string.comments),
            fontWeight = FontWeight.Bold,
        )
        LazyColumn(modifier = modifier.padding(8.dp)) {
            items(comments) { comment ->
                OutlinedTextField(
                    value = comment.comment,
                    onValueChange = {
                        println("edit comment")
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(5.dp),
                )
            }
        }
    }
}

@Composable
fun RawMarkdownEditor(
    markdown: String,
    onMarkdownChange: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = markdown,
        onValueChange = onMarkdownChange,
        modifier = modifier,
        placeholder = { Text(stringResource(Res.string.empty_task_description)) },
        textStyle = MaterialTheme.typography.bodyMedium.copy(
            fontFamily = FontFamily.Monospace
        )
    )
}