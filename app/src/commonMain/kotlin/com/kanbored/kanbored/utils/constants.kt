package com.kanbored.kanbored.utils

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
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

val emptyTask: KanbanTask =
    KanbanTask(
        id = 0,
        title = "",
        description = "",
        dateCreation = 0,
        colorId = "",
        projectId = 0,
        columnId = 0,
        ownerId = 0,
        position = 0,
        isActive = 0,
        dateCompleted = 0,
        score = 0,
        dateDue = 0,
        categoryId = 0,
        creatorId = 0,
        dateModification = 0,
        reference = "",
        dateStarted = 0,
        timeSpent = 0,
        timeEstimated = 0,
        dateMoved = 0,
        recurrenceStatus = 0,
        recurrenceTrigger = 0,
        recurrenceFactor = 0,
        recurrenceTimeframe = 0,
        recurrenceBasedate = 0,
        recurrenceParent = 0,
        recurrenceChild = 0,
        priority = 0
    )