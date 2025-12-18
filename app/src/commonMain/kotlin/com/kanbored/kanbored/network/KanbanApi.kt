package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.utils.endPoint
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.Query

interface KanbanApi {
    @POST(endPoint)
    suspend fun login(
        @Body kanbanRequest: KanbanRequest = createKanbanRequest(KanbanMethod.GetMe)
    ): KanbanLoginResponse

    @POST(endPoint)
    suspend fun getAllProjects(
        @Body kanbanRequest: KanbanRequest = createKanbanRequest(KanbanMethod.GetAllProjects)
    ): KanbanResponse<List<KanbanProject>, KanbanError>

    @POST(endPoint)
    suspend fun createProject(
        @Query("name") name: String,
        @Body kanbanRequest: KanbanRequest = createKanbanRequest(
            KanbanMethod.CreateProject,
            KanbanParams(name = name)
        )
    ): KanbanResponse<Int, KanbanError>
}

@Serializable
data class KanbanParams(
    @SerialName("project_id")
    val projectId: Int? = null,
    val name: String? = null,
    val identifier: String? = null,
    val email: String? = null,
    val list: List<String>? = null,
)

internal fun createKanbanRequest(
    kanbanMethod: KanbanMethod,
    params: KanbanParams? = null
): KanbanRequest {
    return if (params?.list != null) {
        KanbanArrayRequest(
            method = kanbanMethod.name,
            id = kanbanMethod.id,
            params = params.list
        )
    } else {
        KanbanParamsRequest(
            method = kanbanMethod.name,
            id = kanbanMethod.id,
            params = params
        )
    }
}