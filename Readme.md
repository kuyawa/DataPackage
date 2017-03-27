# DataPackage - Swift

DataPackage is a containerized solution to the problem of data portability and collaboration. This is the standard version developed in Swift according to the specs in [FrictionlessData.io](http://frictionlessdata.io).

### To create a DataPackage:

```Swift
let pack = DataPackage()
pack.info.name = "GDP"
pack.info.license = "PDDL 1.0"
pack.save(path: "/Documents/WorldData/")
```

### To load a DataPackage:

```Swift
let pack = DataPackage(path: "/Documents/WorldData/")
print(pack.info.name)
print(pack.info.license)
```

### To load resources:

```Swift
let resource = pack.getResource(name: "gdp")
let data = resource.data()
for row in data {
    print(row)
}
```

### To work with data tables and statistics:

```Swift
let table = resource.dataTable()
let sum = table.sum(col: 3)
let avg = table.avg(col: 3)
print("Total GDP: ", sum)
print("Average GDP: ", avg)
```

### To change data in a table:

```Swift
let table = resource.dataTable()
let row = table.find("2014", col: 2)
row[4] = 123456789.95
print("Row: ", row)
```

### To save a DataPackage as json:

```Swift
pack.name = "GDP Updated"
pack.author = "Taylor Swift"
pack.save() // Saves the json pack only, to save the data use export
```

### To export the data as CSV files packed as Zip:

```Swift
pack.export(zip: true)
```

### How to add this library to your project:

In order to use this library all you need to do is add this repo to your Package Manifest and it will be ready to use in your application:

```Swift
import PackageDescription

let package = Package(
    name: "DataPackageApp",
    dependencies: [
        .Package(url: "https://github.com/kuyawa/DataPackage", majorVersion: 1, minor: 0)
    ]
)
```

**Warning**: Linux compatibility has not been tested yet.

### Final notes:

This is an ongoing project and will be updated regularly.

DataPackage specifications can be found here: [DataPackage specs](https://specs.frictionlessdata.io/data-package/)

For guides and tutorials: [DataPackage guides](http://frictionlessdata.io/guides/)