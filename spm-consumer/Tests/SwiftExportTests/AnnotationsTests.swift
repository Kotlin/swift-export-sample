import Testing
// Declarations that require an opt-in in Kotlin are Swift SPI
@_spi(com$github$jetbrains$swiftexport$ExperimentalSampleApi) import Shared

struct AnnotationsTests {

    @Test func optInRequirementsAreSpi() {
        #expect(experimentalGreeting() == "Hello from an experimental API")
    }

    @Test func documentationAndRenames() {
        // KDoc is available in Xcode quick help for `documented(name:)`
        #expect(documented(name: "Swift") == "Hello, Swift")
        #expect(newApi() == "new")
    }
}
