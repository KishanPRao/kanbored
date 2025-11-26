package com.kanbored.kanbored.screen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.viewmodel.compose.viewModel
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.viewmodel.KanbanViewModel

@Composable
fun HomeScreen(kanbanVM: KanbanViewModel) {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        Text("HOME")
    }
}

@Preview
@Composable
fun HomeScreenPreview() {
    val context = LocalContext.current
    AppTheme(darkTheme = false) {
        // TODO: avoid plugging actual repo/db into preview
        val kanbanVM = viewModel<KanbanViewModel> { KanbanViewModel(context) }
        HomeScreen(kanbanVM)
    }
}