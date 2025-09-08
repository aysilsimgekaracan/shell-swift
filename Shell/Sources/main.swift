// The Swift Programming Language
// https://docs.swift.org/swift-book

while true {
    print("$ ", terminator: "")

    if let input = readLine() {

        guard input != "exit 0" else {
            break
        }

        print("\(input): command not found")
    }
}
