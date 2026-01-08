package com.kanbored.kanbored.utils

import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.KanbanParams

private var mockApiStorageId = 0

// Replaces commonMain/src/util/model_utils.kt:ModelUtils for testing
@Suppress("unused")
object ModelUtils {

    fun createApiStorage(
        kanbanMethod: KanbanMethod,
        kanbanParams: KanbanParams,
        updateId: Int
    ): ApiStorage {
        return ApiStorage(kanbanMethod, kanbanParams, updateId, apiStorageId = ++mockApiStorageId)
    }
}