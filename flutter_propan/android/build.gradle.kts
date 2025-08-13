import com.android.build.gradle.BaseExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.gradle.api.JavaVersion
import org.gradle.api.file.Directory
import org.gradle.api.Plugin
import org.gradle.api.Action

plugins {
  // ...

  // Add the dependency for the Google services Gradle plugin
  id("com.google.gms.google-services") version "4.4.3" apply false

}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    plugins.whenPluginAdded(object : Action<Plugin<*>> {
        override fun execute(plugin: Plugin<*>) {
            when (plugin.javaClass.name) {
                "com.android.build.gradle.AppPlugin",
                "com.android.build.gradle.LibraryPlugin" -> {
                    extensions.findByType(BaseExtension::class.java)?.apply {
                        compileSdkVersion(35)
                        defaultConfig {
                            minSdk = 23
                            targetSdk = 35
                        }
                        compileOptions {
                            sourceCompatibility = JavaVersion.VERSION_11
                            targetCompatibility = JavaVersion.VERSION_11
                        }
                    }
                }

                "org.jetbrains.kotlin.gradle.plugin.KotlinAndroidPluginWrapper" -> {
                    tasks.withType(KotlinCompile::class.java).configureEach {
                        kotlinOptions.jvmTarget = "11"
                    }
                }
            }
        }
    })

    // ✅ FORCE ALL JavaCompile tasks to use Java 11
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "11"
        targetCompatibility = "11"
    }

    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
