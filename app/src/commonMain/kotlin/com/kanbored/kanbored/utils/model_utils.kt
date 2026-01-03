package com.kanbored.kanbored.utils

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.model.KanbanUrl

fun createKanbanProject(name: String): KanbanProject {
    return KanbanProject(
        id = Int.MIN_VALUE,
        name = name,
        isActive = true,
        token = "",
        lastModified = getTimestampInSec().toInt(),
        isPublic = 0,
        isPrivate = 0,
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
        enableGlobalTags = 1,
        isTrelloImported = false,
        url = KanbanUrl("", "")
    )
}

fun createKanbanTask(title: String): KanbanTask {
    val time = getTimestampInSec().toInt()
    return KanbanTask(
        id = Int.MIN_VALUE,
        title = title,
        description = "",
        dateCreation = time,
        colorId = "yellow", // TODO: language dependent?
        projectId = 0,
        columnId = 0,
        ownerId = 0,
        position = 0,
        isActive = true,
        dateCompleted = 0,
        score = 0,
        dateDue = 0,
        categoryId = 0,
        creatorId = 0,
        dateModification = time,
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
}