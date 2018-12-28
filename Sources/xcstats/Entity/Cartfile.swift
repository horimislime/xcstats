import Foundation

struct Cartfile {
    
    struct Dependency {
        let name: String
    }
    
    let dependencies: [Dependency]
    
    private static let matcher = Regex(pattern: "[github|git|binary] [\"|\']([0-9a-zA-Z_\\.\\+\\/\\-]+)[\"|\']")
    
    static func from(fileURL url: URL) -> Cartfile? {
        
        guard let content = try? String(contentsOf: url) else {
            return nil
        }
        
        let deps = content.components(separatedBy: .newlines).compactMap { line -> Dependency? in
            let matchedStrings = matcher.matched(line)
            guard matchedStrings.count >= 1 else { return nil }
            return Dependency(name: matchedStrings[0])
        }
        
        return Cartfile(dependencies: deps)
    }
}
