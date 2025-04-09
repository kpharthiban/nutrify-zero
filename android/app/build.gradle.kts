// Add these imports at the very top of the build.gradle.kts file if they aren't there
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Read local.properties file
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties") // Use double quotes for strings

if (localPropertiesFile.exists() && localPropertiesFile.isFile) {
    // Use try-with-resources equivalent in Kotlin
    FileInputStream(localPropertiesFile).use { fis ->
        localProperties.load(fis)
    }
} else {
     println("Warning: local.properties file not found.")
}

// Read the specific property into a variable (declare type : String)
// Provide a default empty string "" using the elvis operator ?: if the key is not found
val mapsApiKey: String = localProperties.getProperty("MAPS_API_KEY") ?: ""

if (mapsApiKey.isEmpty()) {
    println("Warning: MAPS_API_KEY not found in local.properties. Check the file or key name.")
    // You could optionally throw an error here if the key is absolutely required for a build
    // throw GradleException("MAPS_API_KEY not found in local.properties")
}

android {
    namespace = "com.example.nutrify_zero"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.nutrify_zero"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // --- USE THIS KOTLIN SYNTAX ---
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
        // Alternative Kotlin syntax (less common but works):
        // manifestPlaceholders.put("MAPS_API_KEY", mapsApiKey)
        // --- END KOTLIN SYNTAX ---
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
