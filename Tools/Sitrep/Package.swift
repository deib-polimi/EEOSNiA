// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

// I added the lib_InternalSwiftSyntaxParser dependency to make Sitrep compatible also with the newer versions of Swift
// and changed the checks to support newer versions of Swift (5.7, 5.7.1)

import PackageDescription

var dependencies: [Target.Dependency] = [
    "SwiftSyntax", "Yams", .product(name: "ArgumentParser", package: "swift-argument-parser"), "lib_InternalSwiftSyntaxParser"
]

var binaryTarget: Target = .binaryTarget(name: "lib_InternalSwiftSyntaxParser",
                                           url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/5.7.1/lib_InternalSwiftSyntaxParser.xcframework.zip",
                                           checksum: "feb332ba0a027812b1ee7f552321d6069a46207e5cd0f64fa9bb78e2a261b366")

// IMPORTANT: IF YOU CHANGE THE BELOW, PLEASE ALSO CHANGE THE LARGE FATALERROR()
// MESSAGE IN FILE.SWIFT TO MATCH THE NEW SWIFT VERSION.
#if swift(>=5.7.1)
let swiftSyntaxVersion = Package.Dependency.Requirement.exact("0.50700.1")
dependencies.append(.product(name: "SwiftSyntaxParser", package: "SwiftSyntax"))
#elseif swift(<5.5)
let swiftSyntaxVersion = Package.Dependency.Requirement.exact("0.50400.0")
#elseif swift(<5.6)
binaryTarget = .binaryTarget(
    name: "lib_InternalSwiftSyntaxParser",
    url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/5.5.2/lib_InternalSwiftSyntaxParser.xcframework.zip",
    checksum: "96bbc9ab4679953eac9ee46778b498cb559b8a7d9ecc658e54d6679acfbb34b8"
),
let swiftSyntaxVersion = Package.Dependency.Requirement.exact("0.50500.1")
#elseif swift(<5.7)
let swiftSyntaxVersion = Package.Dependency.Requirement.exact("0.50600.1")
binaryTarget = .binaryTarget(
    name: "lib_InternalSwiftSyntaxParser",
    url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/5.6/lib_InternalSwiftSyntaxParser.xcframework.zip",
    checksum: "88d748f76ec45880a8250438bd68e5d6ba716c8042f520998a438db87083ae9d"
),
#elseif swift(>=5.7)
let swiftSyntaxVersion = Package.Dependency.Requirement.exact("0.50700.0")
binaryTarget = .binaryTarget(
    name: "lib_InternalSwiftSyntaxParser",
    url: "https://github.com/keith/StaticInternalSwiftSyntaxParser/releases/download/5.7/lib_InternalSwiftSyntaxParser.xcframework.zip",
    checksum: "99803975d10b2664fc37cc223a39b4e37fe3c79d3d6a2c44432007206d49db15"
)
#endif

let package = Package(
    name: "Sitrep",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "SitrepCore", targets: ["SitrepCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.4"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", swiftSyntaxVersion)
    ],
    targets: [
        binaryTarget,
        .executableTarget(name: "Sitrep", dependencies: ["SitrepCore",
                                               .product(name: "ArgumentParser",
                                                        package: "swift-argument-parser")]),
        .target(name: "SitrepCore", dependencies: dependencies),
        .testTarget(name: "SitrepCoreTests", dependencies: ["SitrepCore"], exclude: ["Inputs"])
    ]
)
