//
//  Created by Dan Federman on 4/27/22.
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

public struct Shell: Sendable {

    public init(path: String, arguments: [String]) {
        self.path = path
        self.arguments = arguments
    }

    /// The path to the shell command.
    public let path: String

    /// The arguments to the shell command that enable executing an arbitrary command.
    public let arguments: [String]

    /// A convenience accessor for zsh shell struct.
    public static let zsh = Shell(path: "/bin/zsh", arguments: ["-c"])

    /// A convenience accessor for a bash shell struct.
    public static let bash = Shell(path: "/bin/bash", arguments: ["-c"])
}
