package com.kanbored.kanbored.network

sealed class KanbanMethod(val id: Int, val name: String, val type: Type) {
    data object GetMe : KanbanMethod(2134420212, "getMe", Type.Authentication)

    // TODO: document why order matters to API storage/retrieval!
    enum class Type {
        Authentication,
        Project,
        Board,
        Column,
        Task,
        Subtask,
        Comment,
        ProjectMetadata,
        TaskMetadata,
    }
}