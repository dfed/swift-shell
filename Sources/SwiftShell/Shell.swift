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

public protocol Shell {
    /// The path to the shell command.
    static var path: String { get }

    /// The arguments to the shell command that enable executing an arbitrary command.
    static var arguments: [String] { get }
}

public struct ZshShell: Shell {
    public static let path = "/bin/zsh"
    public static let arguments = ["-c"]
}

public struct BashShell: Shell {
    public static let path = "/bin/bash"
    public static let arguments = ["-c"]
}
