package com.kanbored.kanbored

import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.KanbanParams
import com.kanbored.kanbored.network.createKanbanRequest
import com.kanbored.kanbored.utils.createJson
import io.kotest.assertions.json.shouldEqualJson
import kotlinx.serialization.json.Json
import kotlin.test.BeforeTest
import kotlin.test.Test

class KanbanApiTest {

    private lateinit var json: Json

    @BeforeTest
    fun setup() {
        json = createJson()
    }

    private fun testKanbanMethod(
        kanbanMethod: KanbanMethod,
        params: KanbanParams?,
        expected: String
    ) {
        val request = createKanbanRequest(
            kanbanMethod, params
        )
        val jsonString = json.encodeToString(request)
        jsonString shouldEqualJson expected
    }

    @Test
    fun testGetMe() {
        testKanbanMethod(
            KanbanMethod.GetMe,
            null,
            """
{
    "jsonrpc": "2.0",
    "method": "getMe",
    "id": 1718627783
}
        """
        )
    }

    @Test
    fun testCreateProjectParams() {
        testKanbanMethod(
            KanbanMethod.CreateProject,
            KanbanParams(
                name = "PHP client"
            ),
            """
    {
        "jsonrpc": "2.0",
        "method": "createProject",
        "id": 1797076613,
        "params": {
            "name": "PHP client"
        }
    }
        """
        )
    }

    @Test
    fun testUpdateProjectParams() {
        testKanbanMethod(
            KanbanMethod.UpdateProject,
            KanbanParams(
                projectId = 1,
                name = "PHP client update",
            ),
            """
{
    "jsonrpc": "2.0",
    "method": "updateProject",
    "id": 1853996288,
    "params": {
        "project_id": 1,
        "name": "PHP client update"
    }
}

        """
        )
    }

    @Test
    fun testEnableProjectParams() {
        testKanbanMethod(
            KanbanMethod.EnableProject,
            KanbanParams(
                list = listOf("1")
            ),
            """
{
    "jsonrpc": "2.0",
    "method": "enableProject",
    "id": 1775494839,
    "params": [
        "1"
    ]
}
        """
        )
    }
}