package com.kanbored.kanbored.test

import android.graphics.Bitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.test.ExperimentalTestApi
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.screen.MainActivity
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import org.junit.Rule
import org.junit.runner.RunWith
import java.io.File
import java.io.FileOutputStream
import javax.inject.Inject
import kotlin.test.BeforeTest
import kotlin.test.Ignore
import kotlin.test.Test

@Ignore("This must be executed manually")
@HiltAndroidTest
@RunWith(AndroidJUnit4::class)
class ScreenshotTest {
    @get:Rule(order = 0)
    val hiltRule = HiltAndroidRule(this)

    @get:Rule(order = 1)
    val composeTestRule = createAndroidComposeRule<MainActivity>()

    @BeforeTest
    fun setup() {
        hiltRule.inject()
    }

    @Inject
    lateinit var connectivityListener: ConnectivityListener

    val timeoutMs = 10_000L

    @OptIn(ExperimentalTestApi::class)
    @Test
    fun captureScreenshots() {
        // TODO: generate (re-usable) mock data and take screenshot
        composeTestRule.takeScreenshot("login.png")
        composeTestRule.onNodeWithText("LOGIN").performClick()
        composeTestRule.waitUntilAtLeastOneExists(
            matcher = hasText("Website Redesign"),
            timeoutMillis = timeoutMs
        )
        composeTestRule.takeScreenshot("projects.png")
        composeTestRule.onNodeWithText("Website Redesign").performClick()
        composeTestRule.waitUntilAtLeastOneExists(
            matcher = hasText("Develop Features"),
            timeoutMillis = timeoutMs
        )
        composeTestRule.onNodeWithText("Develop Features").performScrollTo().assertIsDisplayed()
        composeTestRule.takeScreenshot("project_screen.png")
        composeTestRule.onNodeWithText("Develop Features").performClick()
        composeTestRule.waitUntilAtLeastOneExists(
            matcher = hasText("Use Next.js v16.0"),
            timeoutMillis = timeoutMs
        )
        composeTestRule.takeScreenshot("task.png")
        println("")
    }
}

private fun ComposeContentTestRule.takeScreenshot(filename: String) {
    onRoot()
        .captureToImage()
        .asAndroidBitmap()
        .saveToFile(filename)
}

private fun Bitmap.saveToFile(filename: String) {
    val context = InstrumentationRegistry.getInstrumentation().targetContext
    val path = context.getExternalFilesDir(null)
    val dir = File(path, "screenshots")
    dir.mkdirs()
    val file = File("${dir.path}/$filename")
    FileOutputStream(file).use { out ->
        compress(Bitmap.CompressFormat.PNG, 100, out)
    }
}
