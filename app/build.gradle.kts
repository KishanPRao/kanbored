import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.multiplatform)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.ksp)
    alias(libs.plugins.room)
    alias(libs.plugins.compose.hot.reload)
    alias(libs.plugins.compose.multiplatform)
    alias(libs.plugins.hilt.android)
}

kotlin {
    compilerOptions {
        freeCompilerArgs.add("-Xexpect-actual-classes")
    }
    androidTarget {
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

            implementation(libs.androidx.navigation.compose)

            implementation(libs.squareup.retrofit)
            implementation(libs.squareup.okhttp3)
            implementation(libs.squareup.okhttp3.logging.interceptor)
            implementation(libs.squareup.kotlinx.serialization)
            implementation(libs.kotlinx.serialization.json)
        }

        commonTest.dependencies {
            implementation(libs.kotlin.test)
            implementation(libs.kotest.assertions.json)
        }

        androidMain.dependencies {
            implementation(compose.preview)

            // Replace DI w/ KMP variant later
            implementation(libs.androidx.hilt.navigation.compose)
            implementation(libs.hilt.android)
            implementation(libs.security.crypto)
            implementation(libs.androidx.ui.tooling)
//
//            testImplementation(libs.junit)
//            androidTestImplementation(libs.androidx.junit)
//            androidTestImplementation(libs.androidx.espresso.core)
//            androidTestImplementation(libs.androidx.ui.test.junit4)
        }
//        jvmMain.dependencies {
//            implementation(compose.desktop.currentOs)
//            implementation(libs.kotlinx.coroutinesSwing)
//            implementation(libs.androidx.sqlite.bundled)
//        }
    }

}

android {
    namespace = "com.kanbored.kanbored"
    compileSdk = libs.versions.android.compileSdk.get().toInt()

    defaultConfig {
        applicationId = "com.kanbored.kanbored"
        minSdk = libs.versions.android.minSdk.get().toInt()
        targetSdk = libs.versions.android.targetSdk.get().toInt()
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
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
        buildConfig = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = libs.versions.compose.multiplatform.get()
    }
}

room {
    schemaDirectory("$projectDir/schemas")
}

dependencies {
    add("kspAndroid", libs.androidx.room.compiler)
    add("kspAndroid", libs.hilt.android.compiler)
//    add("kspJvm", libs.androidx.room.compiler)
}