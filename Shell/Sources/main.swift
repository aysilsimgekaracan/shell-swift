// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum ShellCommand: String {
    case echo, type, exit
}

struct Shell {
    func run() {
        while true {
            print("$ ", terminator: "")
            fflush(stdout)

            guard let input = readLine(), !input.isEmpty else { continue }

            if input == "exit 0" {
                break
            }

            handleInput(input)
        }

    }

    private func handleInput(_ input: String) {
        let components = input.split(separator: " ")
        guard let commandStr = components.first else { return }

        let command = String(commandStr)
        let arguments = components.dropFirst().map(String.init)

        if let shellCommand = ShellCommand(rawValue: command) {
            executeBuiltinCommand(shellCommand, arguments: arguments)
        } else {
            executeExternalCommand(command, arguments: arguments)
        }
    }

    private func executeBuiltinCommand(_ command: ShellCommand, arguments: [String]) {
        switch command {
        case .echo:
            print(arguments.joined(separator: " "))
        case .type:
            handleTypeCommand(arguments: arguments)
        case .exit:
            exit(0)
        }
    }

    private func handleTypeCommand(arguments: [String]) {
        let argumentString = arguments.joined(separator: " ")

        if ShellCommand(rawValue: argumentString) != nil {
            print("\(argumentString) is a shell builtin")
        } else {
            let paths = getEnvironmentPaths()
            var commandFound = false
            for path in paths {
                let fullPath = URL(fileURLWithPath: path)
                    .appendingPathComponent(argumentString)
                    .path

                if checkFileExistsAndExecutable(for: fullPath) {
                    print("\(argumentString) is \(fullPath)")
                    commandFound = true
                    break
                }
            }

            if commandFound == false {
                print("\(argumentString): not found")
            }
        }
    }

    private func executeExternalCommand(_ command: String, arguments: [String]) {
        let paths = getEnvironmentPaths()
        var commandFound = false
        for path in paths {
            let fullPath = URL(fileURLWithPath: path)
                .appendingPathComponent(command)
                .path

            if checkFileExistsAndExecutable(for: fullPath) {
                let output = bash(path: fullPath, arguments: arguments)
                print(output, terminator: "")
                commandFound = true
                break
            }
        }

        if commandFound == false {
            print("\(command): not found")
        }
    }

    private func getEnvironmentPaths() -> [String] {
        guard let pathString = ProcessInfo.processInfo.environment["PATH"],
            !pathString.isEmpty
        else {
            return []
        }

        return pathString.components(separatedBy: ":")
            .filter { !$0.isEmpty }  // used to removed empty strings
    }

    private func checkFileExistsAndExecutable(for path: String) -> Bool {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: path) {
            if fileManager.isExecutableFile(atPath: path) {
                return true
            }

            return false
        }

        return false
    }

    @discardableResult
    private func bash(path: String, arguments: [String]) -> String {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments

        try! process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

}

let shell = Shell()
shell.run()
