plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.multiplatform)
//    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.ksp)
    alias(libs.plugins.room)
//    alias(libs.plugins.composeHotReload) apply false
}

kotlin {
//    androidTarget()
    linuxX64 {
        binaries {
            executable()
        }
    }
    androidTarget {
        compilations.all {
//            kotlinOptions {
//                jvmTarget = "1.8"  // or "11" depending on your setup
//            }
        }
    }

    sourceSets {
        val androidMain by getting {
            dependencies {
                // Android-specific dependencies
            }
        }
        val commonMain by getting {
            dependencies {
                // Shared dependencies
            }
        }
    }

}

android {
    namespace = "com.kanbored.kanbored"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.kanbored.kanbored"
        minSdk = 24
        targetSdk = 36
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
}

room {
    schemaDirectory("$projectDir/schemas")
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.ui)
    implementation(libs.androidx.ui.graphics)
    implementation(libs.androidx.ui.tooling.preview)
    implementation(libs.androidx.material3)
    implementation(libs.androidx.material.icons.extended)
    implementation(libs.androidx.room.runtime)
    implementation(libs.androidx.room.ktx)
//    ksp(libs.androidx.room.compiler)
//    kspJvm(libs.androidx.room.compiler)
//    kspAndroid(libs.androidx.room.compiler)
    add("kspAndroid", libs.androidx.room.compiler)

    implementation(libs.androidx.navigation.compose)

    implementation(libs.squareup.retrofit)
    implementation(libs.squareup.okhttp3)
    implementation(libs.squareup.okhttp3.logging.interceptor)
    implementation(libs.squareup.kotlinx.serialization)
    implementation(libs.kotlinx.serialization.json)

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.ui.test.junit4)
    debugImplementation(libs.androidx.ui.tooling)
    debugImplementation(libs.androidx.ui.test.manifest)
}