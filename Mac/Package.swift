// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WatchPointer",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "WatchPointer",
            exclude: ["Info.plist"],
            linkerSettings: [
                // Embed Info.plist so macOS has a Bluetooth usage string for this CLI.
                .unsafeFlags(["-Xlinker", "-sectcreate", "-Xlinker", "__TEXT", "-Xlinker", "__info_plist",
                              "-Xlinker", "Sources/WatchPointer/Info.plist"])
            ]
        )
    ]
)
