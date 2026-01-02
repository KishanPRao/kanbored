package com.kanbored.kanbored.screen

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.PlaylistAdd
import androidx.compose.material.icons.filled.Archive
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.EditNote
import androidx.compose.material.icons.filled.Unarchive
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
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
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.ui.theme.LocalDimensions
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.emptyTask
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import com.mikepenz.markdown.m3.Markdown
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.edit
import kanbored.app.generated.resources.empty_task_description
import kanbored.app.generated.resources.topbar_add_checklist
import kanbored.app.generated.resources.topbar_archive
import kanbored.app.generated.resources.topbar_delete
import kanbored.app.generated.resources.topbar_rename
import kanbored.app.generated.resources.topbar_settings
import kanbored.app.generated.resources.topbar_unarchive
import org.jetbrains.compose.resources.stringResource

@Composable
fun TaskScreen(
    topBarVM: TopBarViewModel,
    kanbanVM: KanbanViewModel,
    projectId: Int,
    columnId: Int,
    taskId: Int,
    modifier: Modifier = Modifier
) {
    var rawMarkdown by remember { mutableStateOf("") }
    var isRawText by remember { mutableStateOf(false) }
    var isArchived by remember { mutableStateOf(false) }
    val kanbanTask: KanbanTask? by kanbanVM.getTask(
        projectId = projectId,
        columnId = columnId,
        taskId = taskId
    ).collectAsState(null)
    val task = kanbanTask ?: emptyTask
    LaunchedEffect(task) {
        topBarVM.saveState()
        topBarVM.updateTitle(task.title)
        topBarVM.showBackButton(true)
        topBarVM.setDropdownItems(
            listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.topbar_rename)) {
                    println("Rename")
                },
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.topbar_delete)) {
                    println("Delete")
                },
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.topbar_settings)) {
                    println("Settings")
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
                    if (isArchived) Res.string.topbar_unarchive else Res.string.topbar_archive
                ),
                onClick = {
                    println("Un/Archive task")
                }
            ),
        ))

    val dimensions = LocalDimensions.current
    Box(modifier = modifier) {
        if (isRawText) {
            RawMarkdownEditor(
                markdown = rawMarkdown,
                onMarkdownChange = { rawMarkdown = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(16.dp)
            )
        } else {
            Markdown(
                content = rawMarkdown,
                modifier = Modifier
                    .fillMaxWidth()
                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(16.dp)
                    .verticalScroll(rememberScrollState()),
            )
        }
        KanbanIconButton(
            if (isRawText) Icons.Filled.EditNote else Icons.Filled.Edit,
            Res.string.edit,
            tint = if (isRawText) Color.Yellow else LocalContentColor.current,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(10.dp),
        ) {
            isRawText = !isRawText
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