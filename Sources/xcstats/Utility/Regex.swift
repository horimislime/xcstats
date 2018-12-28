import Foundation

struct Regex {
    
    private let expression: NSRegularExpression?
    
    init(pattern: String) {
        expression = try? NSRegularExpression(pattern: pattern)
    }
    
    func matched(_ string: String) -> [String] {
        guard let result = expression?.matches(in: string, options: .withTransparentBounds, range: NSRange(location: 0, length: string.count)), !result.isEmpty, result[0].numberOfRanges >= 2 else {
            return []
        }
        
        var matchedStrings: [String] = []
        for i in 1..<result[0].numberOfRanges {
            let range = result[0].range(at: i)
            let start = string.index(string.startIndex, offsetBy: range.location)
            let end = string.index(start, offsetBy: range.length)
            matchedStrings.append(String(string[start..<end]))
        }
        
        return matchedStrings
    }
}
