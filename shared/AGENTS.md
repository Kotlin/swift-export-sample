# AGENTS.md

Rules for the Kotlin API of `:shared`. The root `AGENTS.md` has the commands and repo-wide rules.

- The API in `src/commonMain/kotlin/com/github/jetbrains/swiftexport/` is split into one file per Swift Export feature. Put new declarations in the matching file.
- Give each group of declarations a one-line comment that says what Swift gets, for example "Flow<User> becomes `KotlinTypedFlow<User>`". Check it against the generated Swift before you commit.
- Platform-specific API goes into `iosMain` or `macosMain`. The generated package uses `#if os(...)` for it.
- Declarations outside `rootPackage` (`com.github.jetbrains.swiftexport`) keep their package as a Swift namespace. Use that only to show the namespace behavior (`nested/`).
- The Kotlin targets are `iosArm64`, `iosSimulatorArm64` and `macosArm64`. There is no `iosX64`, so Xcode builds for the simulator must use arm64 only.
- After changing the API, export the package and run both the `spm-consumer` tests and the app XCTests.
