import org.jetbrains.compose.internal.utils.localPropertiesFile
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.plugin.KotlinSourceSetTree
import org.jetbrains.kotlin.konan.properties.Properties
import org.jetbrains.kotlin.konan.properties.hasProperty

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.multiplatform)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.ksp)
    alias(libs.plugins.buildConfig)
    alias(libs.plugins.room)
    alias(libs.plugins.compose.hot.reload)
    alias(libs.plugins.compose.multiplatform)
    alias(libs.plugins.hilt.android)
}

val appPackageName = "com.kanbored.kanbored"

kotlin {
    compilerOptions {
        freeCompilerArgs.add("-Xexpect-actual-classes")
    }
    androidTarget {
        // Includes commonTest dependencies into androidInstrumentedTest
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        instrumentedTestVariant {
            sourceSetTree.set(KotlinSourceSetTree.test)
        }
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    /***
    TODO: Enable JVM again
    Currently, follows a half-baked KMP design, with hilt/dagger (and other) android libraries being used with commonMain, to be replaced with Koin or kotlin-inject
     ***/
//    jvm {
//        compilerOptions {
//            jvmTarget.set(JvmTarget.JVM_11)
//        }
//
//        @OptIn(ExperimentalKotlinGradlePluginApi::class)
//        mainRun {
//            mainClass.set("com.kanbored.kanbored.MainKt")
//        }
//    }

    sourceSets {
        all {
            languageSettings {
                optIn("androidx.compose.material3.ExperimentalMaterial3Api")
                optIn("org.jetbrains.compose.resources.ExperimentalResourceApi")
            }
        }

        commonMain.dependencies {
            implementation(libs.androidx.material.icons.extended)
            implementation(libs.androidx.room.runtime)
            implementation(compose.runtime)
            implementation(compose.foundation)
            implementation(compose.material3)
            implementation(compose.ui)
            implementation(compose.components.resources)
            implementation(compose.components.uiToolingPreview)
            implementation(libs.androidx.lifecycle.viewmodel.compose)
            implementation(libs.androidx.lifecycle.runtime.compose)
            implementation(libs.multiplatform.markdown.renderer)
            implementation(libs.multiplatform.markdown.renderer.m3)
            implementation(libs.reorderable)
            implementation(libs.kermit)

            implementation(libs.androidx.navigation.compose)

            implementation(libs.squareup.retrofit)
            implementation(libs.squareup.okhttp3)
            implementation(libs.squareup.okhttp3.logging.interceptor)
            implementation(libs.squareup.kotlinx.serialization)
            implementation(libs.kotlinx.serialization.json)
        }

        commonTest.dependencies {
            implementation(libs.kotlin.test)
            implementation(libs.kotlinx.coroutines.test)
            implementation(libs.kotest.assertions.json)
            implementation(libs.mockk)
        }

        androidMain.dependencies {
            implementation(compose.preview)

            // Replace DI w/ KMP variant later
            implementation(libs.androidx.hilt.navigation.compose)
            implementation(libs.hilt.android)
            implementation(libs.security.crypto)
            implementation(libs.androidx.ui.tooling)
            implementation(libs.androidx.work.runtime.ktx)
            implementation(libs.androidx.hilt.common)
            implementation(libs.androidx.hilt.work)

//
//            testImplementation(libs.junit)
//            androidTestImplementation(libs.androidx.junit)
//            androidTestImplementation(libs.androidx.espresso.core)
//            androidTestImplementation(libs.androidx.ui.test.junit4)
        }

        androidUnitTest.dependencies {
            implementation(libs.junit)
            implementation(libs.androidx.core.ktx)
        }
        androidInstrumentedTest.dependencies {
            implementation(libs.androidx.junit)
            implementation(libs.androidx.espresso.core)
            implementation(libs.androidx.ui.test.junit4)
            implementation(libs.mockk.android)
            implementation(libs.androidx.work.testing)
            implementation(libs.hilt.android.testing)
        }
//        androidMainTest.dependencies {
//            implementation(libs.androidx.work.testing)
//        }
//        jvmMain.dependencies {
//            implementation(compose.desktop.currentOs)
//            implementation(libs.kotlinx.coroutinesSwing)
//            implementation(libs.androidx.sqlite.bundled)
//        }
    }

}

android {
    namespace = appPackageName
    compileSdk = libs.versions.android.compileSdk.get().toInt()

    defaultConfig {
        applicationId = appPackageName
        minSdk = libs.versions.android.minSdk.get().toInt()
        targetSdk = libs.versions.android.targetSdk.get().toInt()
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "com.kanbored.kanbored.HiltTestRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = libs.versions.composeMultiplatform.get()
    }
}

room {
    schemaDirectory("$projectDir/schemas")
}

buildConfig {
    packageName(appPackageName)
    // TODO: Use only during debug mode; for release, embed empty values
    if (!localPropertiesFile.exists()) {
        error(
            """
            local.properties file doesn't exist!
        """.trimIndent()
        )
    }
    val properties = Properties()
    localPropertiesFile.inputStream().use { properties.load(it) }
    val propertiesKeys = listOf("API_BASE_URL", "API_USERNAME", "API_PASSWORD")
    propertiesKeys.forEach { key ->
        if (!properties.hasProperty(key)) {
            error(
                """
            local.properties doesn't contain `${key}` property!
        """.trimIndent()
            )
        }
        buildConfigField(
            "String",
            key,
            "\"${properties.getProperty(key)}\""
        )
    }
}

dependencies {
    add("kspAndroid", libs.androidx.room.compiler)
    add("kspAndroid", libs.hilt.android.compiler)
    add("kspAndroid", libs.androidx.hilt.compiler)
    add("kspAndroidAndroidTest", libs.hilt.android.compiler)
    add("kspAndroidAndroidTest", libs.androidx.hilt.compiler)
}