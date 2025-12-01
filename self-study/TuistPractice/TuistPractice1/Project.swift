import ProjectDescription

let project = Project(
    name: "TuistPractice1",
    targets: [
        .target(
            name: "TuistPractice1",
            destinations: .iOS,
            product: .app,
            bundleId: "app.tuistPractice1.TuistPractice1",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["TuistPractice1/Sources/**"],
            resources: ["TuistPractice1/Resources/**"],
            dependencies: [
                .project(target: "Bob", path: "Projects/Bob"),
                .project(target: "Gil", path: "Projects/Gil"),
            ]
        ),
        .target(
            name: "TuistPractice1Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.TuistPractice1Tests",
            infoPlist: .default,
            sources: ["TuistPractice1/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TuistPractice1")]
        ),
    ]
)
