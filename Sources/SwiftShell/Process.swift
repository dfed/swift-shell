//
// Created by Dan Federman on 4/21/22.
// Copyright © 2022 Dan Federman.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import os

extension Process {
	// MARK: Public

	/// Executes a shell command.
	/// - Parameters:
	///   - command: The shell command to execute.
	///   - shell: The path to the shell from which to execute. Defaults to zsh.
	///   - directory: The directory within which the command will execute.
	///   - successCodes: The exit codes that represent success of this operation.
	@discardableResult
	public static func execute(
		_ command: String,
		from shell: Shell = .zsh,
		within directory: Directory = .pwd,
		successCodes: Set<Int32> = [0]
	) throws -> String {
		let script = makeCommand(command, executeWithin: directory)
		let task = Process()
		task.executableURL = shell.url
		task.arguments = shell.arguments + [script]

		let stdout = Pipe()
		task.standardOutput = stdout
		let standardOutput = OSAllocatedUnfairLock(initialState: "")
		stdout.fileHandleForReading.readabilityHandler = { handle in
			standardOutput.withLock {
				$0 += String(
					decoding: handle.availableData,
					as: UTF8.self
				)
			}
		}
		defer {
			stdout.cleanup()
		}

		let stderr = Pipe()
		task.standardError = stderr
		let standardError = OSAllocatedUnfairLock(initialState: "")
		stderr.fileHandleForReading.readabilityHandler = { handle in
			standardError.withLock {
				$0 += String(
					decoding: handle.availableData,
					as: UTF8.self
				)
			}
		}
		defer {
			stderr.cleanup()
		}

		try task.run()
		task.waitUntilExit()
		guard successCodes.contains(task.terminationStatus) else {
			throw ShellError(
				terminationStatus: task.terminationStatus,
				stdout: standardOutput.withLock { $0 },
				stderr: standardError.withLock { $0 },
				command: command
			)
		}

		return standardOutput.withLock { $0 }
	}

	// MARK: Private

	private static func makeCommand(
		_ command: String,
		executeWithin directory: Directory
	) -> String {
		switch directory {
		case .pwd:
			// We're already in the current directory – there's nothing to wrap.
			command
		case let .path(path):
			"""
			pushd \(path)
			\(command)
			popd
			"""
		case let .url(url):
			"""
			pushd '\(url.path(percentEncoded: false))'
			\(command)
			popd
			"""
		}
	}
}

extension Pipe {
	fileprivate func cleanup() {
		fileHandleForReading.readabilityHandler = nil
		// We shouldn't need to do this per the docs, but
		// we've seen that not doing this can lead to an error:
		// Error: Error Domain=NSPOSIXErrorDomain Code=9 "Bad file descriptor"
		try? fileHandleForReading.close()
	}
}
