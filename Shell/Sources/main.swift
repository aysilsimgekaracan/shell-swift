// The Swift Programming Language
// https://docs.swift.org/swift-book

while true {
    print("$ ", terminator: "")

    if let input = readLine() {
        print("\(input): command not found")
    }
}
