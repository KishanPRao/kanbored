package com.kanbored.kanbored.utils

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanUrl

const val endPoint = "/jsonrpc.php"

// 30 seconds
const val refreshStateDelay = 30_000L

val emptyProject: KanbanProject = KanbanProject(
    id = Int.MIN_VALUE,
    name = "",
    isActive = false,
    token = "",
    lastModified = 0,
    isPrivate = 0,
    isPublic = 0,
    description = "",
    identifier = "",
    startDate = "",
    endDate = "",
    ownerId = 0,
    priorityDefault = 0,
    priorityStart = 0,
    priorityEnd = 0,
    email = "",
    predefinedEmailSubjects = "",
    perSwimlaneTaskLimits = 0,
    taskLimit = 0,
    enableGlobalTags = 0,
    isTrelloImported = false,
    url = KanbanUrl("", ""),
)