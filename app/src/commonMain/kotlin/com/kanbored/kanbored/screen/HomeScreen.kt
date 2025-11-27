package com.kanbored.kanbored.screen

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.utils.UiEvent
import com.kanbored.kanbored.utils.getContext
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
fun HomeScreen(kanbanVM: KanbanViewModel) {
    var isRefreshing by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) {
        kanbanVM.uiEventFlow.collectLatest { event ->
            when (event) {
                UiEvent.HideLocalLoading -> isRefreshing = false
                UiEvent.ShowLocalLoading -> isRefreshing = true
                else -> {}
            }
        }
    }
    PullToRefreshBox(
        isRefreshing = isRefreshing,
        onRefresh = {
            kanbanVM.viewModelScope.launch {
                kanbanVM.refreshProjects()
            }
        },
        modifier = Modifier.fillMaxSize(),
    ) { ProjectGrid(kanbanVM) }
}

@Composable
fun ProjectGrid(kanbanVM: KanbanViewModel) {
    val projects by kanbanVM.projects.collectAsStateWithLifecycle()
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(4.dp, 12.dp, 4.dp, 4.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        items(projects) { project ->
            println("project: ${project.name}")
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f)
                    .clickable {},
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

@Preview
@Composable
fun HomeScreenPreview() {
    val context = getContext()
    AppTheme(darkTheme = false) {
        // TODO: avoid plugging actual repo/db into preview
        val kanbanVM = viewModel<KanbanViewModel> { KanbanViewModel(context) }
        HomeScreen(kanbanVM)
    }
}