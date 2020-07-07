import Foundation

//let serverUrl = URL(string: "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-macos10.15-x86_64.tar.gz")!
let serverUrl = URL(string: "https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.29-macos10.14-x86_64.tar.gz")!

let task = Process()
task.launchPath = "/usr/bin/killall"
task.arguments = ["mysqld"]
task.launch()
task.waitUntilExit()
sleep(1)

let testDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
let testCacheDirectory = testDirectory.appendingPathComponent(".cache")

let fileManager = FileManager.default

try! fileManager.createDirectory(at: testCacheDirectory, withIntermediateDirectories: true, attributes: nil)

var nextPort: Int32 = 3306

#if os(Linux)
let environmentPath = testCacheDirectory.appendingPathComponent(serverUrl.deletingPathExtension().lastPathComponent)
#elseif os(macOS)
let environmentPath = testCacheDirectory.appendingPathComponent(serverUrl.deletingPathExtension().deletingPathExtension().lastPathComponent)
#endif
if !fileManager.fileExists(atPath: environmentPath.path) {
  let tarPath = testCacheDirectory.appendingPathComponent(serverUrl.lastPathComponent)
  if !fileManager.fileExists(atPath: tarPath.path) {
    print("Downloading \(serverUrl)...")
    let tar = try! Data(contentsOf: serverUrl)
    try! tar.write(to: tarPath)
  }
  print("Untarring \(tarPath.path) to \(testCacheDirectory.path)...")

  #if os(Linux)
  let task = Process()
  task.launchPath = "/usr/bin/ar"
  task.arguments = [
    "vx",
    tarPath.path
  ]
  task.launch()
  task.waitUntilExit()

  if !fileManager.fileExists(atPath: environmentPath.path) {
    try! fileManager.createDirectory(at: environmentPath, withIntermediateDirectories: true, attributes: nil)
  }

  let dataTask = Process()
  dataTask.launchPath = "/bin/tar"
  dataTask.arguments = [
    "-xf",
    URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent("data.tar.xz").path,
    "-C",
    environmentPath.path
  ]
  dataTask.launch()
  dataTask.waitUntilExit()
  #else
  let task = Process()
  task.launchPath = "/usr/bin/tar"
  task.arguments = [
    "-xf",
    tarPath.path,
    "-C",
    testCacheDirectory.path
  ]
  task.launch()
  task.waitUntilExit()
  #endif
}

let serverPath = environmentPath.appendingPathComponent("bin/mysqld")
let dataPath = environmentPath.appendingPathComponent("data")

print("Initializing server \(serverPath.path)...")
print("Server exists at \(fileManager.fileExists(atPath: serverPath.path))...")

if fileManager.fileExists(atPath: dataPath.path) {
  try! fileManager.removeItem(at: dataPath)
}

try! fileManager.createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)

let initializationTask = Process()
initializationTask.launchPath = serverPath.path
initializationTask.arguments = [
  "--basedir=\(environmentPath.path)",
  "--datadir=\(dataPath.path)",
  "--initialize-insecure"  // We don't require a password.
]
initializationTask.launch()
initializationTask.waitUntilExit()

let runTask = Process()
runTask.launchPath = serverPath.path
runTask.arguments = [
  "--basedir=\(environmentPath.path)",
  "--datadir=\(dataPath.path)",
  "--port=3306",
]
runTask.launch()
