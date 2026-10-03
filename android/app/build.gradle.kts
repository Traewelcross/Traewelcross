import java.io.File
import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    //id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

if (gradle.startParameter.taskNames.any { it.contains("play", ignoreCase = true) }) {
    apply(plugin = "com.google.gms.google-services")
}
val keyPropertiesFile = File("key.properties")
require(keyPropertiesFile.exists()) { "key.properties file not found." }

val keyProperties = Properties().apply {
    load(FileInputStream(keyPropertiesFile))
}
android {
    namespace = "de.traewelcross"
    compileSdk = 37 //flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    flavorDimensions += "default"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "de.traewelcross"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    productFlavors {
        create("foss") {
            dimension = "default"
            versionNameSuffix = "-foss"
            applicationIdSuffix = ".foss"
        }
        create("play") {
            dimension = "default"
            versionNameSuffix = "-play"
        }
    }
    signingConfigs {
        create("release") {
            keyAlias = keyProperties.getProperty("keyAlias")
            keyPassword = keyProperties.getProperty("keyPassword")
            storeFile = file(keyProperties.getProperty("storeFile"))
            storePassword = keyProperties.getProperty("storePassword")
        }
        getByName("debug") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
            applicationIdSuffix = ".debug"
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    add("playImplementation", "com.google.android.gms:play-services-wearable:20.0.1")
    add("playImplementation", "org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")
}