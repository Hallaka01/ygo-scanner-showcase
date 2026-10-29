// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YGOScannerShowcase",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [.library(name: "ScannerCore", targets: ["ScannerCore"])],
    targets: [
        .target(name: "ScannerCore", path: "Examples/ScannerCore"),
        .testTarget(name: "ScannerCoreTests", dependencies: ["ScannerCore"], path: "Tests/ScannerCoreTests")
    ]
)
