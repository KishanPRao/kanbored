package com.kanbored.kanbored

import android.content.Context
import android.util.Log
import androidx.concurrent.futures.await
import androidx.hilt.work.HiltWorkerFactory
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.work.Configuration
import androidx.work.WorkInfo
import androidx.work.WorkManager
import androidx.work.impl.utils.SynchronousExecutor
import androidx.work.testing.WorkManagerTestInitHelper
import com.kanbored.kanbored.network.ApiWorker
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.MockConnectivityListener
import com.kanbored.kanbored.network.NetworkStatus
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.persistent.MockDatabase
import com.kanbored.kanbored.repository.KanbanRepository
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.test.runTest
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import javax.inject.Inject
import kotlin.test.AfterTest
import kotlin.test.BeforeTest
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@HiltAndroidTest
@RunWith(AndroidJUnit4::class)
class ApiWorkerTest {
    @get:Rule(order = 0)
    val hiltRule = HiltAndroidRule(this)

    @Inject
    lateinit var database: KanbanDatabase

    @Inject
    lateinit var workerFactory: HiltWorkerFactory

    @Inject
    lateinit var repository: KanbanRepository

    @Inject
    lateinit var connectivityListener: ConnectivityListener

    private lateinit var workManager: WorkManager
    private lateinit var context: Context


    @BeforeTest
    fun setup() {
        println("setup")
        hiltRule.inject()
        context = ApplicationProvider.getApplicationContext()
        val config = Configuration.Builder()
            .setMinimumLoggingLevel(Log.DEBUG)
            .setExecutor(SynchronousExecutor())
            .setWorkerFactory(workerFactory)
            .build()

        WorkManagerTestInitHelper.initializeTestWorkManager(context, config)
        workManager = WorkManager.getInstance(context)
    }


    @AfterTest
    fun tearDown() {
        println("tearDown")
        workManager.cancelAllWork()
        (database as MockDatabase).clear()

    }

    suspend fun logDatabase() {
        println("***************** Data *****************")
        println("Projects: ${database.projectDao().getAllSync()}")
        println("Columns: ${database.columnDao().getAllSync()}")
        println("Tasks: ${database.taskDao().getAllSync()}")
        println("Subtasks: ${database.subtaskDao().getAllSync()}")
        println("Comments: ${database.commentDao().getAllSync()}")
        println("API Storage: ${database.apiStorageDao().getAllSync()}")
        println("***************** Fin *****************")
    }

    fun runAndWait(runBlock: suspend () -> Unit) = runBlocking {
        val job = launch {
            workManager.getWorkInfosForUniqueWorkFlow(ApiWorker.WORK_NAME)
                .first { workInfos -> workInfos.isNotEmpty() && workInfos.first().state.isFinished }
        }
        runBlock()
        job.join()
        val workInfo = workManager
            .getWorkInfosForUniqueWork(ApiWorker.WORK_NAME)
            .await()
            .first()
        println("work info: $workInfo")
        assertEquals(workInfo.state, WorkInfo.State.SUCCEEDED)
    }

    @Test
    fun testCreate2Projects() = runTest {
        val dao = database.projectDao()
        runAndWait {
            val connectivityListener = connectivityListener as MockConnectivityListener
            connectivityListener.setNetworkStatus(NetworkStatus.Unavailable)
            connectivityListener.setNetworkStatus(NetworkStatus.Available)
            repository.createProject("test1")
            repository.createProject("test2")
//            connectivityListener.setNetworkStatus(NetworkStatus.Available)
        }
        val projects = dao.getAllSync()
        assertEquals(2, projects.size)
        assertTrue { projects.any { it.id == 1 } }
        assertTrue { projects.any { it.id == 2 } }
    }

    @Test
    fun testCreateProjectsAndColumns() = runTest {
        runAndWait {
            val connectivityListener = connectivityListener as MockConnectivityListener
            connectivityListener.setNetworkStatus(NetworkStatus.Unavailable)
            // TODO: If available from start, cannot work (uses local project id after project actually has real id)
            // TODO: likely shouldn't be an issue with real-time since we have DB foreign key on_update cascade (needs proper testing)
//            connectivityListener.setNetworkStatus(NetworkStatus.Available)
            val project1 = repository.createProject("proj1")
            logDatabase()
            val project2 = repository.createProject("proj2")
            logDatabase()
            repository.createColumn(project1.id, "col1")
            logDatabase()
            repository.createColumn(project2.id, "col2")
            logDatabase()
            repository.createColumn(project1.id, "col3")
            connectivityListener.setNetworkStatus(NetworkStatus.Available)
            logDatabase()
        }
        logDatabase()
        val projects = database.projectDao().getAllSync()
        val columns = database.columnDao().getAllSync()
        assertEquals(2, projects.size)
        assertEquals(3, columns.size)
        val proj1 = projects.first { it.name == "proj1" }
        val proj2 = projects.first { it.name == "proj2" }
        assertTrue { projects.all { it.id > 0 } }
        assertEquals(proj1.id, columns.first { it.title == "col1" }.projectId)
        assertEquals(proj1.id, columns.first { it.title == "col3" }.projectId)
        assertEquals(proj2.id, columns.first { it.title == "col2" }.projectId)
    }

    @Test
    fun testCreateProjectsAndUpdate() = runTest {
        runAndWait {
            val connectivityListener = connectivityListener as MockConnectivityListener
            connectivityListener.setNetworkStatus(NetworkStatus.Unavailable)
            val project1 = repository.createProject("proj1")
            val project2 = repository.createProject("proj2")
            repository.updateProject(project1.copy(name = "project 1"))
            repository.updateProject(project1.copy(name = "Project 1"))
            repository.updateProject(project2.copy(name = "project 2"))
            connectivityListener.setNetworkStatus(NetworkStatus.Available)
        }
        logDatabase()
        val projects = database.projectDao().getAllSync()
        assertEquals(2, projects.size)
        assertTrue { projects.any { it.name == "Project 1" } }
        assertTrue { projects.any { it.name == "project 2" } }
    }
}