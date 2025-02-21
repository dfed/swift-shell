# swift-shell
[![CI Status](https://img.shields.io/github/actions/workflow/status/dfed/swift-shell/ci.yml?branch=main)](https://github.com/dfed/swift-shell/actions?query=workflow%3ACI+branch%3Amain)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://spdx.org/licenses/MIT.html)

A simple wrapper for executing shell commands from Swift

## Usage

```
import SwiftShell

// Getting output from a shell command:
let output = try Process.execute(#"echo "Hello, world!""#)

// Getting output from a shell command within a specific directory:
let output = try Process.execute("ls", within: .path("~/"))

// Getting output from a shell command within a specific directory:
let output = try Process.execute("ls", within: .url(.init(filePath: "/tmp/")))
```

## Requirements

- Swift 6
- Xcode 16.0
