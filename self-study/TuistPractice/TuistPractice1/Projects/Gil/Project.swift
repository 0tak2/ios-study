//
//  Project.swift
//  Config
//
//  Created by 임영택 on 7/18/25.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Gil",
    targets: [
        .target(
            name: "Gil",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "app.gil.TuistPractice1",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        ),
        .target(
            name: "GilTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "app.gil.TuistPractice1Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Gil")]
        ),
    ]
)
