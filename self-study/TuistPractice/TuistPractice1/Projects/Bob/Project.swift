//
//  Project.swift
//  Config
//
//  Created by 임영택 on 7/18/25.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Bob",
    targets: [
        .target(
            name: "Bob",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "app.bob.TuistPractice1",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        ),
        .target(
            name: "BobTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "app.bob.TuistPractice1Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Bob")]
        ),
    ]
)
