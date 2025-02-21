//
//  Created by Dan Federman on 4/27/22.
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

public struct Shell: Sendable {
	public init(url: URL, arguments: [String]) {
		self.url = url
		self.arguments = arguments
	}

	public init(path: String, arguments: [String]) {
		url = .init(filePath: path)
		self.arguments = arguments
	}

	/// The url to the shell command.
	public let url: URL

	/// The arguments to the shell command that enable executing an arbitrary command.
	public let arguments: [String]

	/// A convenience accessor for zsh shell struct.
	public static let zsh = Shell(url: .init(filePath: "/bin/zsh"), arguments: ["-c"])

	/// A convenience accessor for a bash shell struct.
	public static let bash = Shell(url: .init(filePath: "/bin/bash"), arguments: ["-c"])
}
