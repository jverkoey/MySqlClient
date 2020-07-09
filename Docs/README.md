# MySql Client Documentation

- [Setup](#setup)
- [Introduction](#introduction)

## Setup

This MySQL client library isn't much use without a MySQL server.

If you don't have one handy, you can spin one up locally by running the included bootstrap command from your terminal:

````
swift run bootstrap https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-macos10.15-x86_64.tar.gz
````

This command will download, extract, and run a MySQL server on your machine. This will configure the server with a passwordless root
user.

## Introduction

In order to connect to a MySQL server you must create a MySqlClient instance configured with your server's details:

```
let client = MySqlClient(to: "<#host#>", username: "<#username#>", password: "<#password#>", database: "<#database#>")
```

Note: if you haven't created a database on your server then you can leave off the database argument for now. You will need to select a
database later though.

You can then execute queries to your MySQL server through the client instance like so:

```
do {
  let response = try client.query("SELECT 'pizza' as food")
  if case let .Results(iterator) = response {
    for row in iterator {
      print(row["food"]) // prints "pizza"
    }
  }
} catch let error {
  print(error)
}
```

try! client.createDatabase(named: databaseName)
try! client.useDatabase(named: databaseName)
```
