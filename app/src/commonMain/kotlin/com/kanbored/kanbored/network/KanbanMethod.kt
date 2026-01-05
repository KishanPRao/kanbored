package com.kanbored.kanbored.network

open class KanbanMethod(val methodId: Int, val methodName: String, val methodType: Int) {
    object GetMe : KanbanMethod(1718627783, "getMe", Type.AUTHENTICATION)
    object GetAllProjects : KanbanMethod(2134420212, "getAllProjects", Type.PROJECT)
    object CreateProject : KanbanMethod(1797076613, "createProject", Type.PROJECT)
    object RemoveProject : KanbanMethod(46285125, "removeProject", Type.PROJECT)
    object UpdateProject : KanbanMethod(1853996288, "updateProject", Type.PROJECT)
    object EnableProject : KanbanMethod(1775494839, "enableProject", Type.PROJECT)
    object GetColumns : KanbanMethod(887036325, "getColumns", Type.COLUMN)
    object AddColumn : KanbanMethod(638544704, "addColumn", Type.COLUMN)
    object GetAllTasks : KanbanMethod(887036325, "getAllTasks", Type.TASK)
    object CreateTask : KanbanMethod(1176509098, "createTask", Type.TASK)
    object GetAllSubtasks : KanbanMethod(2087700490, "getAllSubtasks", Type.SUBTASK)
    object GetAllComments : KanbanMethod(148484683, "getAllComments", Type.COMMENT)

}

// TODO: document why order matters to API storage/retrieval!
object Type {
    const val AUTHENTICATION = 0
    const val BOARD = 1  // TODO: remove? Any real need later?
    const val PROJECT = 2
    const val COLUMN = 3
    const val TASK = 4
    const val SUBTASK = 5
    const val COMMENT = 6
    const val PROJECT_METADATA = 7
    const val TASK_METADATA = 8
}