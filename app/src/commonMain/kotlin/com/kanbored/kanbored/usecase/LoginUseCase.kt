package com.kanbored.kanbored.usecase

import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.KanbanRequest
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.ConfigRepository
import com.kanbored.kanbored.utils.PresentableText
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.login_err_unknown
import kotlinx.coroutines.Dispatchers
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class LoginUseCase @Inject constructor(
    private val configRepository: ConfigRepository,
    private val apiProvider: ApiProvider,
) {
    suspend operator fun invoke(
        baseUrl: String,
        userName: String,
        password: String
    ): Result<Unit> {
        try {
            configRepository.saveConfig(
                baseUrl = baseUrl,
                username = userName,
                password = password,
            )

            val response = with(Dispatchers.IO) {
                println("api provider login")
                apiProvider.getKanbanApi().login(
                    KanbanRequest(
                        method = KanbanMethod.GetMe.name,
                        id = KanbanMethod.GetMe.id,
                    )
                )
            }
            if (response.result != null) {
                // TODO: store user info? AuthConfig stores more info (user id, etc), sends it as result?
                configRepository.authenticateConfig()
                println("login: $response")
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.login_err_unknown))
            }
        } catch (e: Exception) {
            println("login error: ${e.message}, ${e.localizedMessage}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.login_err_unknown)
            )
        }
    }
}
