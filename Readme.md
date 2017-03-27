# DataPackage - Swift

DataPackage is a containerized solution to the problem of data portability and collaboration. This is the standard version developed in Swift according to the specs in [FrictionlessData.io](http://frictionlessdata.io).

### To create a DataPackage:

```
let pack = DataPackage()
pack.info.name = "GDP"
pack.info.license = "PDDL 1.0"
pack.save(path: "/Documents/WorldData/")
```

### To load a DataPackage:

```
let pack = DataPackage(path: "/Documents/WorldData/")
print(pack.info.name)
print(pack.info.license)
```

### To load resources:

```
let resource = pack.getResource(name: "gdp")
let data = resource.data()
for row in data {
    print(row)
}
```

### To work with data tables and statistics:

```
let table = resource.dataTable()
let sum = table.sum(col: 3)
let avg = table.avg(col: 3)
print("Total GDP: ", sum)
print("Average GDP: ", avg)
```

### To change data in a table:

```
let table = resource.dataTable()
let row = table.find("2014", col: 2)
row[4] = 123456789.95
print("Row: ", row)
```

### To save a DataPackage as json:

```
pack.name = "GDP Updated"
pack.author = "Taylor Swift"
pack.save() // Saves the json pack only, to save the data use export
```

### To export the data as CSV files packed as Zip:

```
pack.export(zip: true)
```

This is an ongoing project and will be updated regularly.

