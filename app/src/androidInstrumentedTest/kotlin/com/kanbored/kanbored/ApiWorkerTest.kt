package com.kanbored.kanbored

import android.content.Context
import android.util.Log
import androidx.hilt.work.HiltWorkerFactory
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.work.Configuration
import androidx.work.WorkManager
import androidx.work.impl.utils.SynchronousExecutor
import androidx.work.testing.WorkManagerTestInitHelper
import com.kanbored.kanbored.network.ApiWorkManager
import com.kanbored.kanbored.network.ApiWorker
import com.kanbored.kanbored.persistent.KanbanDatabase
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import kotlinx.coroutines.test.runTest
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import javax.inject.Inject
import kotlin.test.AfterTest
import kotlin.test.BeforeTest

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
    lateinit var apiWorkManager: ApiWorkManager

    private lateinit var workManager: WorkManager
    private lateinit var context: Context


    @BeforeTest
    fun setup() {
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
        workManager.cancelAllWork()
    }

    @Test
    fun testCreateProject() = runTest {
        apiWorkManager.createProject("test1")
        apiWorkManager.createProject("test2")
        val dao = database.projectDao()
        println("all projs: ${dao.getAllSync()}")
        // TODO: end up with 2 projs; wait for work to finish
        val workInfo = workManager.getWorkInfosForUniqueWork(ApiWorker.WORK_NAME)
            .get()
            .first()
        println("work info: $workInfo")
    }
}