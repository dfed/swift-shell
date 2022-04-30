# swift-shell
A simple wrapper for executing shell commands from Swift

## Requirements

- Swift 5.6
- Xcode 13.3+

# Usage

```
import SwiftShell

// Getting output from a shell command:
let output = try Process.execute(#"echo "Hello, world!""#)

// Getting output from a shell command within a specific directory:
let output = try Process.execute("ls", within: .path("~/"))
```
