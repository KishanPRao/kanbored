package com.kanbored.kanbored.repository

import android.content.Context
import com.kanbored.kanbored.R
import com.kanbored.kanbored.model.KanbanUserSession
import com.kanbored.kanbored.network.KanbanLoginRequest
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.network.RetrofitClient
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.persistent.KanbanUserSessionEntity
import com.kanbored.kanbored.utils.PresentableText
import kotlinx.coroutines.Dispatchers

class KanbanRepository(context: Context) {
    private val database: KanbanDatabase = KanbanDatabase.getDatabase(context)

//    private val kanbanApi by lazy { RetrofitClient.kanbanApi }

    suspend fun getAuthenticatedUserSessionSync(): KanbanUserSession =
        database.userDao().getAuthenticatedUserSessionSync().toModel()

    suspend fun login(
        hostUrl: String,
        userName: String,
        password: String
    ): Result<KanbanUserSession> {
        println("login repo")
        // TODO: better way!
        try {
            val response = with(Dispatchers.IO) {
                val kanbanApi = RetrofitClient.createApi(
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
                val entity = KanbanUserSessionEntity(
                    userId = response.result.id,
                    userName = userName,
                    password = password,
                    hostUrl = hostUrl,
                    appRole = response.result.role,
                    authenticated = true,
                )
                println("login: $response, $entity")
//            database.userDao().insertOrUpdate(entity)
                return Result.Success(entity.toModel())
            } else if (response.error != null) {
                println("login err: ${response.error}, ${response.error.code}, ${response.error.message}")
                if (response.error.code == 401) {
                    return Result.Error(PresentableText.StringResource(R.string.login_err_unauthorized))
                }
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