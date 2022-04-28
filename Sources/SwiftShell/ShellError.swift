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

/// An error thrown after shell execution when the status code is non-zero.
public struct ShellError: Error {
    /// The exit code returned by the command.
    public let terminationStatus: Int32
    /// Text written to standard out during execution of the command.
    public let stdout: String
    /// Text written to standard error during execution of the command.
    public let stderr: String
    /// The command that was being executed.
    public let command: String
}

