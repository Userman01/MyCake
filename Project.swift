import ProjectDescription

// MARK: - Versioning

let targetVersion = "15.0"
let appVersion = "1.0.0"
let appBuildNumber = "1"

// MARK: - BaseURLFlags

enum BaseURLFlags: String {
    case dynamic = "DYNAMIC_BASE_URL"
    case test = "TEST_BASE_URL"
    case prod = "PROD_BASE_URL"
}

let debugBaseURL: BaseURLFlags = .dynamic
let releaseBaseURL: BaseURLFlags = .prod

// MARK: - AnalyticsFlags

enum AnalyticsFlags: String {
    case test = "ANALYTICS_TEST"
    case prod = "ANALYTICS_PROD"
}

let debugAnalyticsMode: AnalyticsFlags = .test
let releaseAnalyticsMode: AnalyticsFlags = .prod

// MARK: - Project

let project =  Project(
    name: "MyCakeAppIOS",
    organizationName: "Petr Postnikov",
    targets: [
        Target(
            name: "MyCake",
            destinations: .init(arrayLiteral: .iPhone, .iPad),
            product: .app,
            bundleId: "ru.mycake",
            deploymentTargets: .iOS(targetVersion),
            infoPlist: .file(path: "Targets/MyCake/Info.plist"),
            sources: ["Targets/MyCake/Sources/**"],
            resources: ["Targets/MyCake/Resources/**"],
            dependencies: [],
            settings: .settings(
                base: SettingsDictionary()
                    .marketingVersion(appVersion)
                    .currentProjectVersion(appBuildNumber)
                    .otherLinkerFlags(["$(OTHER_LDFLAGS) -ObjC"]),
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: SettingsDictionary()
                            .swiftCompilationMode(.singlefile)
                            .swiftOptimizationLevel(.oNone)
                            .otherSwiftFlags("-D \(debugBaseURL.rawValue)", "-D \(debugAnalyticsMode.rawValue)"),
                        xcconfig: "Targets/MyCake/BuildSettings.xcconfig"
                    ),
                    .release(
                        name: "Release",
                        settings: SettingsDictionary()
                            .swiftCompilationMode(.wholemodule)
                            .swiftOptimizationLevel(.o)
                            .otherSwiftFlags("-D \(releaseBaseURL.rawValue)", "-D \(releaseAnalyticsMode.rawValue)", "-D RELEASE"),
                        xcconfig: "Targets/MyCake/BuildSettings.xcconfig"
                    )
                ]
            )
        )
    ],
    resourceSynthesizers: [
        .assets(),
        .strings(),
        .files(extensions: ["json", "mp3", "caf"])
    ]
)
