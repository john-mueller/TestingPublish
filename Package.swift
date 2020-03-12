// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TestingPublish",
    products: [
        .executable(name: "TestingPublish", targets: ["TestingPublish"])
    ],
    dependencies: [
        .package(path: "/Users/johnmueller/Documents/GitRepos/Publish/")
    ],
    targets: [
        .target(
            name: "TestingPublish",
            dependencies: ["Publish"]
        )
    ]
)
