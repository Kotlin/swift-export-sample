# AGENTS.md

Rules for the Xcode project and the SwiftUI app. The root `AGENTS.md` has the commands and repo-wide rules.

## Xcode project

- The project uses buildable folders. New Swift files in `appleApp/` or `Tests/` are picked up without editing `project.pbxproj`.
- One multiplatform target (`appleApp`) builds for iOS and macOS. Put iOS-only API (UIKit, `iosMain` declarations) behind `#if os(iOS)`.
- `MemberImportVisibility` is on. Import every module whose members a file uses: `KotlinStdlib` for members inherited from stdlib classes such as `Throwable.message`, `KotlinRuntime` for `KotlinBase`, and `ModuleD` and `IoInsertKoinKoinCore` for the stubs of the hidden `:module-d` and Koin.
- Keep `SWIFT_DEFAULT_ACTOR_ISOLATION` unset. The generated Kotlin declarations are nonisolated, so with main actor isolation every Swift override of a Kotlin member fails to compile.
- Keep `ENABLE_USER_SCRIPT_SANDBOXING = NO` on the `appleApp` target. The Run Script phase runs Gradle, which reads and writes outside the sandbox.

## SwiftUI

- The app opens on `Catalog/FeatureCatalog.swift`. Each feature screen is `Features/XView.swift`, paired with the Kotlin file `X.kt` in `:shared`; `Catalog/DemoComponents.swift` holds the shared row and screen views.
- Attach sheets and other presentations outside the lazy `List`. A presentation attached to a `List` section is dismissed when the List rebuilds that section.
- Kotlin objects are not observable. Keep Kotlin results that drive the UI in `@State`, and keep frequently changing state in the smallest view that uses it.
- SwiftUI declares `Shape`, so write `Shared.Shape` for the Kotlin class.

## Tests

- `Tests/Tests.swift` mirrors the `spm-consumer` tests with XCTest against the modules embedded in the app. Add a test here when you add one there.
- Run the tests on both macOS and an iOS simulator. UIKit checks run on iOS only.
