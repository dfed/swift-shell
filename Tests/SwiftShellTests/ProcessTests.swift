//
//  Created by Dan Federman on 4/21/22.
//  Copyright © 2022 Dan Federman.
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
import SwiftShell
import Testing

struct ProcessTests {
	@Test
	func execute_capturesStandardOutput() throws {
		#expect(try Process.execute(#"echo "hello, world""#) == "hello, world\n")
	}

	@Test
	func execute_propagatesErrorCode() throws {
		try #require(performing: {
			try Process.execute(#"cat non-existent-file"#)
		}, throws: {
			($0 as? ShellError)?.terminationStatus == 1
		})
	}

	@Test
	func execute_propagatesStandardError() throws {
		try #require(performing: {
			try Process.execute(#"cat non-existent-file"#)
		}, throws: {
			($0 as? ShellError)?.stderr == "cat: non-existent-file: No such file or directory\n"
		})
	}

	@Test
	func execute_propagatesStandardOutput() throws {
		try #require(performing: {
			try Process.execute(#"echo 'hi'; cat non-existent-file"#)
		}, throws: {
			($0 as? ShellError)?.stdout == "hi\n"
		})
	}

	@Test
	func execute_propagatesCommandInError() throws {
		try #require(performing: {
			try Process.execute(#"cat non-existent-file"#)
		}, throws: {
			($0 as? ShellError)?.command == #"cat non-existent-file"#
		})
	}

	@Test
	func execute_runsCommandFromExpectedDirectoryWhenPathProvided() throws {
		let tempDirectory = FileManager
			.default
			.temporaryDirectory
			.appendingPathComponent(UUID().uuidString)

		let expectedFileNames = [
			"Hello",
			"world",
		]

		try Process.execute("mkdir -p \(tempDirectory.relativePath)")
		for fileName in expectedFileNames {
			let filePath = tempDirectory.appendingPathComponent(fileName)
			try Process.execute("touch \(filePath.relativePath)")
		}

		let output = try Process.execute(
			#"ls"#,
			within: .path(tempDirectory.relativePath)
		)
		#expect(output == "Hello\nworld\n")
	}

	@Test
	func execute_runsCommandFromExpectedDirectoryWhenURLProvided() throws {
		let tempDirectory = FileManager
			.default
			.temporaryDirectory
			.appendingPathComponent(UUID().uuidString)

		let expectedFileNames = [
			"Hello",
			"world",
		]

		try Process.execute("mkdir -p \(tempDirectory.relativePath)")
		for fileName in expectedFileNames {
			let filePath = tempDirectory.appendingPathComponent(fileName)
			try Process.execute("touch \(filePath.relativePath)")
		}

		let output = try Process.execute(
			#"ls"#,
			within: .url(tempDirectory)
		)
		#expect(output == "Hello\nworld\n")
	}

	@Test
	func execute_runsCommandFromExpectedDirectoryWhenURLWithSpaceProvided() throws {
		let tempDirectory = FileManager
			.default
			.temporaryDirectory
			.appendingPathComponent("\(UUID().uuidString) with space")

		let expectedFileNames = [
			"Hello",
			"world",
		]

		try Process.execute("mkdir -p '\(tempDirectory.relativePath)'")
		for fileName in expectedFileNames {
			let filePath = tempDirectory.appendingPathComponent(fileName)
			try Process.execute("touch '\(filePath.relativePath)'")
		}

		let output = try Process.execute(
			#"ls"#,
			within: .url(tempDirectory)
		)
		#expect(output == "Hello\nworld\n")
	}

	@Test
	func execute_executesMultilineCommands() throws {
		let output = try Process.execute("""
		echo "Hello, world!"
		echo "Goodbye, moon"
		""")
		#expect(output == "Hello, world!\nGoodbye, moon\n")
	}
}
