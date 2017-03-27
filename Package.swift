import PackageDescription

let package = Package(
    name: "DataPackageApp",
    dependencies: [
        .Package(url: "https://github.com/kuyawa/DataPackage", majorVersion: 1, minor: 0)
    ]
)