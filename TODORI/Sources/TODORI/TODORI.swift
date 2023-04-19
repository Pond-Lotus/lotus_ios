@main
public struct TODORI {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(TODORI().text)
    }
}
