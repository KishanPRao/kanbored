package com.kanbored.kanbored.repository

import android.content.Context
import com.kanbored.kanbored.R
import com.kanbored.kanbored.model.KanbanUserSession
import com.kanbored.kanbored.network.KanbanApi
import com.kanbored.kanbored.network.KanbanLoginRequest
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.network.RetrofitClient
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.persistent.KanbanUserSessionEntity
import com.kanbored.kanbored.utils.PresentableText
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class KanbanRepository(context: Context, scope: CoroutineScope) {
    private val database: KanbanDatabase = KanbanDatabase.getDatabase(context)
    private lateinit var kanbanApi: KanbanApi

    init {
        scope.launch {
            val userSession = getAuthenticatedUserSessionSync()
            if (userSession != null) {
                kanbanApi = RetrofitClient.createApi(
                    userName = userSession.userName,
                    password = userSession.password,
                    hostUrl = userSession.hostUrl,
                )
            }
        }
    }

    suspend fun getAuthenticatedUserSessionSync(): KanbanUserSession? {
        return with(Dispatchers.IO) {
            database.userDao().getAuthenticatedUserSessionSync()?.toModel()
        }
    }

    suspend fun login(
        hostUrl: String,
        userName: String,
        password: String
    ): Result<KanbanUserSession> {
        try {
            val kanbanApi: KanbanApi
            val response = with(Dispatchers.IO) {
                kanbanApi = RetrofitClient.createApi(
                    userName = userName,
                    password = password,
                    hostUrl = hostUrl,
                )
                kanbanApi.login(
                    KanbanLoginRequest(
                        method = KanbanMethod.GetMe.name,
                        id = KanbanMethod.GetMe.id,
                        jsonrpc = "2.0",
                    )
                )
            }
            if (response.result != null) {
                this.kanbanApi = kanbanApi
                val entity = KanbanUserSessionEntity(
                    userId = response.result.id,
                    userName = userName,
                    password = password,
                    hostUrl = hostUrl,
                    appRole = response.result.role,
                    authenticated = true,
                )
                println("login: $response, $entity")
                database.userDao().insertOrUpdate(entity)
                return Result.Success(entity.toModel())
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.StringResource(R.string.login_err_unknown))
            }
        } catch (e: Exception) {
            println("login error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.StringResource(R.string.login_err_unknown)
            )
        }
    }
}