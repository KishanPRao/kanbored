package com.kanbored.kanbored.network

import kotlinx.serialization.Serializable

@Serializable
sealed class KanbanMethod(val id: Int, val name: String, val type: Type) {
    data object GetMe : KanbanMethod(1718627783, "getMe", Type.Authentication)
    data object GetAllProjects : KanbanMethod(2134420212, "getAllProjects", Type.Project)
    data object CreateProject : KanbanMethod(1797076613, "createProject", Type.Project)
    data object UpdateProject : KanbanMethod(1853996288, "updateProject", Type.Project)
    data object EnableProject : KanbanMethod(1775494839, "enableProject", Type.Project)
    data object GetColumns : KanbanMethod(887036325, "getColumns", Type.Column)
    data object GetAllTasks : KanbanMethod(887036325, "getAllTasks", Type.Task)
    data object GetAllSubtasks : KanbanMethod(2087700490, "getAllSubtasks", Type.Subtask)
    data object GetAllComments : KanbanMethod(148484683, "getAllComments", Type.Comment)

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