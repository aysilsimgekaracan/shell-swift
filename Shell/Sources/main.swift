// The Swift Programming Language
// https://docs.swift.org/swift-book

while true {
    print("$ ", terminator: "")

    if let input = readLine() {
        let inputArray = input.split(separator: " ")
        let command = inputArray.first
        let arguments = inputArray.dropFirst()

        guard input != "exit 0", let command else {
            break
        }

        if command == "echo" {
            print(arguments.joined(separator: " "))
        } else {

            print("\(input): command not found")
        }

    }
}
