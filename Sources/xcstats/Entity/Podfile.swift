import Foundation

struct Podfile {
    
    struct Dependency {
        let name: String
    }
    
    let dependencies: [Dependency]
    
    private static let matcher = Regex(pattern: "pod [\"|\']([0-9a-zA-Z_\\.\\+\\/\\-]+)[\"|\']")
    
    static func from(fileURL url: URL) -> Podfile? {
        
        guard let content = try? String(contentsOf: url) else {
            return nil
        }
        
        let deps = content.components(separatedBy: .newlines).compactMap { line -> Dependency? in
            let matchedStrings = matcher.matched(line)
            guard matchedStrings.count >= 1 else { return nil }
            return Dependency(name: matchedStrings[0])
        }
        
        return Podfile(dependencies: deps)
    }
}
