//
//  Created by Dan Federman on 4/21/22.
//  Copyright © 2022 Dan Federman.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS"BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

extension Process {

    // MARK: Public

    @discardableResult
    /// Executes a shell command.
    /// - Parameters:
    ///   - command: The shell command to execute.
    ///   - shell: The path to the shell from which to execute. Defaults to zsh.
    ///   - directory: The directory within which the command will execute.
    public static func execute(
        _ command: String,
        from shell: Shell = .zsh,
        within directory: Directory = .pwd)
    throws
    -> String
    {
        let script = makeCommand(command, executeWithin: directory)
        let task = Process()
        task.launchPath = shell.rawValue
        task.arguments = ["-c", script]

        let stdout = Pipe()
        task.standardOutput = stdout
        let stderr = Pipe()
        task.standardError = stderr

        try task.run()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw ShellError(
                code: task.terminationStatus,
                stdout: try stdout.readOutput(),
                stderr: try stderr.readOutput(),
                command: command)
        }

        return try stdout.readOutput()
    }

    // MARK: Private

    private static func makeCommand(
        _ command: String,
        executeWithin directory: Directory)
    -> String
    {
        switch directory {
        case .pwd:
            // We're already in the current directory – there's nothing to wrap.
            return command
        case .path(let path):
            return """
            pushd \(path)
            \(command)
            popd
            """
        }
    }
}

extension Pipe {
    fileprivate func readOutput() throws -> String {
        defer {
          // We shouldn't need to do this per the docs, but
          // we've seen that not doing this can lead to an error:
          // Error: Error Domain=NSPOSIXErrorDomain Code=9 "Bad file descriptor"
          try? fileHandleForReading.close()
        }
        guard let readData = try fileHandleForReading.readToEnd() else {
            return ""
        }

        return String(
            decoding: readData,
            as: UTF8.self)
    }
}
