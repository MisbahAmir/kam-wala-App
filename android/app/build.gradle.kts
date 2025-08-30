android {
    namespace "com.example.kam_wala_app"
    compileSdkVersion 33

    defaultConfig {
        applicationId "com.example.kam_wala_app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"

        multiDexEnabled true
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
    implementation 'androidx.multidex:multidex:2.0.1'
}
