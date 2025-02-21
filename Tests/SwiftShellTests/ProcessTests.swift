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

import SwiftShell
import XCTest

class ProcessTests: XCTestCase {
	func test_execute_capturesStandardOutput() throws {
		XCTAssertEqual(try Process.execute(#"echo "hello, world""#), "hello, world\n")
	}

	func test_execute_propagatesErrorCode() throws {
		XCTAssertThrowsError(try Process.execute(#"cat non-existent-file"#)) {
			XCTAssertEqual(
				($0 as? ShellError)?.terminationStatus,
				1
			)
		}
	}

	func test_execute_propagatesStandardError() throws {
		XCTAssertThrowsError(try Process.execute(#"cat non-existent-file"#)) {
			XCTAssertEqual(
				($0 as? ShellError)?.stderr,
				"cat: non-existent-file: No such file or directory\n"
			)
		}
	}

	func test_execute_propagatesStandardOutput() throws {
		XCTAssertThrowsError(try Process.execute(#"echo 'hi'; cat non-existent-file"#)) {
			XCTAssertEqual(
				($0 as? ShellError)?.stdout,
				"hi\n"
			)
		}
	}

	func test_execute_propagatesCommandInError() throws {
		XCTAssertThrowsError(try Process.execute(#"cat non-existent-file"#)) {
			XCTAssertEqual(
				($0 as? ShellError)?.command,
				#"cat non-existent-file"#
			)
		}
	}

	func test_execute_runsCommandFromExpectedDirectory() throws {
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
		XCTAssertEqual(output, "Hello\nworld\n")
	}

	func test_execute_executesMultilineCommands() throws {
		let output = try Process.execute("""
		echo "Hello, world!"
		echo "Goodbye, moon"
		""")
		XCTAssertEqual(output, "Hello, world!\nGoodbye, moon\n")
	}
}
