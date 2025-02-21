# swift-shell
A simple wrapper for executing shell commands from Swift

## Requirements

- Swift 6
- Xcode 16.0

# Usage

```
import SwiftShell

// Getting output from a shell command:
let output = try Process.execute(#"echo "Hello, world!""#)

// Getting output from a shell command within a specific directory:
let output = try Process.execute("ls", within: .path("~/"))

// Getting output from a shell command within a specific directory:
let output = try Process.execute("ls", within: .url(.init(filePath: "/tmp/")))
```
