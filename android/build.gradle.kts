allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureAndroid = { proj: Project ->
        val android = proj.extensions.findByName("android")
        if (android != null && android is com.android.build.gradle.BaseExtension) {
            if (android.namespace == null) {
                // Try to read package name from AndroidManifest.xml to match it exactly
                val manifestFile = proj.file("src/main/AndroidManifest.xml")
                var pkgName: String? = null
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    val matcher = java.util.regex.Pattern.compile("package=\"([^\"]+)\"").matcher(content)
                    if (matcher.find()) {
                        pkgName = matcher.group(1)
                    }
                }
                android.namespace = pkgName ?: "com.example.${proj.name.replace("-", "_")}"
            }
        }
    }
    if (project.state.executed) {
        configureAndroid(project)
    } else {
        project.afterEvaluate {
            configureAndroid(project)
        }
    }
}

