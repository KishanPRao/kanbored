import org.jetbrains.compose.desktop.application.dsl.TargetFormat
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.multiplatform)
//    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.ksp)
    alias(libs.plugins.room)
//    alias(libs.plugins.composeHotReload) apply false
    alias(libs.plugins.compose.hot.reload)
    alias(libs.plugins.compose.multiplatform)
}

kotlin {
    androidTarget {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    jvm {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }

        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        mainRun {
            mainClass.set("com.kanbored.kanbored.MainKt")
        }
    }

    sourceSets {
        all {
            languageSettings {
                optIn("androidx.compose.material3.ExperimentalMaterial3Api")
                optIn("org.jetbrains.compose.resources.ExperimentalResourceApi")
            }
        }
//        val androidMain by getting {
//            dependencies {
//                // Android-specific dependencies
//            }
//        }
//        val commonMain by getting {
//            dependencies {
//                // Shared dependencies
//            }
//        }

//        linuxX64Main.dependencies {
//            implementation(libs.androidx.core.ktx)
////            implementation(libs.androidx.lifecycle.runtime.ktx)
//            implementation(libs.androidx.activity.compose)
//            implementation(libs.androidx.compose.bom)
//            implementation(libs.androidx.ui)
//            implementation(libs.androidx.ui.graphics)
////            implementation(libs.androidx.ui.tooling.preview)
////            implementation(libs.androidx.material3)
////            implementation(libs.androidx.material.icons.extended)
//            implementation(libs.androidx.room.runtime)
////            implementation(libs.androidx.room.ktx)  //  kotlinx-coroutines-android
////    ksp(libs.androidx.room.compiler)
////    kspJvm(libs.androidx.room.compiler)
////    kspAndroid(libs.androidx.room.compiler)
////            add("kspAndroid", libs.androidx.room.compiler)
//
//            implementation(libs.androidx.navigation.compose)
//
////            implementation(libs.squareup.retrofit)
////            implementation(libs.squareup.okhttp3)
////            implementation(libs.squareup.okhttp3.logging.interceptor)
////            implementation(libs.squareup.kotlinx.serialization)
//            implementation(libs.kotlinx.serialization.json)
//
////            testImplementation(libs.junit)
////            androidTestImplementation(libs.androidx.junit)
////            androidTestImplementation(libs.androidx.espresso.core)
////            androidTestImplementation(platform(libs.androidx.compose.bom))
////            androidTestImplementation(libs.androidx.ui.test.junit4)
////            debugImplementation(libs.androidx.ui.tooling)
////            debugImplementation(libs.androidx.ui.test.manifest)
//        }

        commonMain.dependencies {
//            implementation(compose.runtime)
//            implementation(compose.foundation)
//            implementation(compose.material3)
//            implementation(compose.ui)
//            implementation(compose.components.resources)
//            implementation(compose.components.uiToolingPreview)
//            implementation(libs.androidx.lifecycle.viewmodelCompose)
//            implementation(libs.androidx.lifecycle.runtimeCompose)

//            implementation(libs.androidx.core.ktx)
//            implementation(libs.androidx.lifecycle.runtime.ktx)
//            implementation(libs.androidx.activity.compose)
//            implementation(project.dependencies.platform(libs.androidx.compose.bom))
//            implementation(libs.androidx.ui)
//            implementation(libs.androidx.ui.graphics)
//            implementation(libs.androidx.ui.tooling.preview)
//            implementation(libs.androidx.material3)
            implementation(libs.androidx.material.icons.extended)
            implementation(libs.androidx.room.runtime)
//            implementation(libs.androidx.room.ktx)


            implementation(compose.runtime)
            implementation(compose.foundation)
            implementation(compose.material3)
            implementation(compose.ui)
            implementation(compose.components.resources)
            implementation(compose.components.uiToolingPreview)
            implementation(libs.androidx.lifecycle.viewmodel.compose)
            implementation(libs.androidx.lifecycle.runtime.compose)
//    ksp(libs.androidx.room.compiler)
//    kspJvm(libs.androidx.room.compiler)
//    kspAndroid(libs.androidx.room.compiler)
//            add(commonMain.get(), libs.androidx.room.compiler)

            implementation(libs.androidx.navigation.compose)

            implementation(libs.squareup.retrofit)
            implementation(libs.squareup.okhttp3)
            implementation(libs.squareup.okhttp3.logging.interceptor)
            implementation(libs.squareup.kotlinx.serialization)
            implementation(libs.kotlinx.serialization.json)

//            testImplementation(libs.junit)
//            androidTestImplementation(libs.androidx.junit)
//            androidTestImplementation(libs.androidx.espresso.core)
//            androidTestImplementation(platform(libs.androidx.compose.bom))
//            androidTestImplementation(libs.androidx.ui.test.junit4)
//            debugImplementation(libs.androidx.ui.tooling)
//            debugImplementation(libs.androidx.ui.test.manifest)
        }

        androidMain.dependencies {
            implementation(compose.preview)
            // TODO: needed?
            implementation(libs.androidx.activity.compose)
        }
        jvmMain.dependencies {
            implementation(compose.desktop.currentOs)
            implementation(libs.kotlinx.coroutinesSwing)
            implementation(libs.androidx.sqlite.bundled)
        }
    }

}

//configurations.all {
//    // TODO: fixes java.lang.NoSuchMethodError: 'long androidx.compose.ui.unit.IntOffset$Companion.getMax-nOcc-ac()'
//    resolutionStrategy {
//        force("org.jetbrains.compose.ui:ui:1.9.3")
//        force("org.jetbrains.compose.runtime:runtime:1.9.3")
//        force("org.jetbrains.compose.foundation:foundation:1.9.3")
//    }
//}

configurations.all {
    // TODO: fixes java.lang.NoSuchMethodError: 'long androidx.compose.ui.unit.IntOffset$Companion.getMax-nOcc-ac()'
    // and java.lang.NoSuchMethodError: 'float androidx.compose.ui.util.MathHelpersKt.fastCbrt(float)'
    resolutionStrategy {
        eachDependency {
            if (requested.group.startsWith("org.jetbrains.compose")) {
                useVersion(libs.versions.composeMultiplatform.get())
            }
        }
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
//    kotlinOptions {
//        jvmTarget = "11"
//    }
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

//dependencies {
//    debugImplementation(compose.uiTooling)
//}
//
//compose.desktop {
//    application {
//        mainClass = "com.kanbored.kanbored.MainKt"
//
//        nativeDistributions {
//            targetFormats(TargetFormat.Dmg, TargetFormat.Msi, TargetFormat.Deb)
//            packageName = "com.kanbored.kanbored"
//            packageVersion = "1.0.0"
//        }
//    }
//}

dependencies {
    add("kspAndroid", libs.androidx.room.compiler)
    add("kspJvm", libs.androidx.room.compiler)
}

//dependencies {
//    implementation(libs.androidx.core.ktx)
//    implementation(libs.androidx.lifecycle.runtime.ktx)
//    implementation(libs.androidx.activity.compose)
//    implementation(platform(libs.androidx.compose.bom))
//    implementation(libs.androidx.ui)
//    implementation(libs.androidx.ui.graphics)
//    implementation(libs.androidx.ui.tooling.preview)
//    implementation(libs.androidx.material3)
//    implementation(libs.androidx.material.icons.extended)
//    implementation(libs.androidx.room.runtime)
//    implementation(libs.androidx.room.ktx)
////    ksp(libs.androidx.room.compiler)
////    kspJvm(libs.androidx.room.compiler)
////    kspAndroid(libs.androidx.room.compiler)
//    add("kspAndroid", libs.androidx.room.compiler)
//
//    implementation(libs.androidx.navigation.compose)
//
//    implementation(libs.squareup.retrofit)
//    implementation(libs.squareup.okhttp3)
//    implementation(libs.squareup.okhttp3.logging.interceptor)
//    implementation(libs.squareup.kotlinx.serialization)
//    implementation(libs.kotlinx.serialization.json)
//
//    testImplementation(libs.junit)
//    androidTestImplementation(libs.androidx.junit)
//    androidTestImplementation(libs.androidx.espresso.core)
//    androidTestImplementation(platform(libs.androidx.compose.bom))
//    androidTestImplementation(libs.androidx.ui.test.junit4)
//    debugImplementation(libs.androidx.ui.tooling)
//    debugImplementation(libs.androidx.ui.test.manifest)
//}