package com.kanbored.kanbored.utils

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask

const val endPoint = "/jsonrpc.php"

// 30 seconds
const val refreshStateDelay = 30_000L

val emptyProject: KanbanProject = createKanbanProject("")

val emptyTask: KanbanTask = createKanbanTask("")