// The Swift Programming Language
// https://docs.swift.org/swift-book

enum ShellCommand: String {
    case echo, type, exit
}

while true {
    print("$ ", terminator: "")

    if let input = readLine() {
        let inputArray = input.split(separator: " ")
        let firstInput: String? = inputArray.first.map { String($0) }
        let arguments = inputArray.dropFirst()

        guard input != "exit 0",
            let firstInput,
            let command =
                ShellCommand(rawValue: firstInput)
        else {
            break
        }

        switch command {
        case .echo:
            print(arguments.joined(separator: " "))
        case .type:
            let argumentString = arguments.joined()
            if ShellCommand(rawValue: argumentString) != nil {
                print("\(argumentString) is a shell builtin")
            } else {
                print("\(argumentString): not found")
            }
        default:
            print("\(input): command not found")
        }
    }
}
