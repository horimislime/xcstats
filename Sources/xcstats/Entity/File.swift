import Foundation

struct FileType: Equatable {
    private let identifier: String
    
    static let swift = FileType(identifier: "Swift")
    static let clangHeader = FileType(identifier: "C Header")
    static let objcImpl = FileType(identifier: "Objective-C Implementation")
    static let storyboard = FileType(identifier: "Storyboard")
    static let xib = FileType(identifier: "Xib")
    static let xcconfig = FileType(identifier: "Xcode Config")
    static let png = FileType(identifier: "Png Image")
    static let jpeg = FileType(identifier: "Jpeg Image")
    static let cartfile = FileType(identifier: "Cartfile")
    static let podfile = FileType(identifier: "Podfile")
    static let packageSwift = FileType(identifier: "Swift Package")
    
    private init(identifier: String) {
        self.identifier = identifier
    }
    
    static func determine(usingFileName name: String) -> FileType {
        
        switch name {
        case "Cartfile":
            return .cartfile
        case "Podfile":
            return .podfile
        case "Package.swift":
            return .packageSwift
        default:
            break
        }
        
        guard let fileExtension = name.split(separator: ".").last else {
            return FileType(identifier: name)
        }
        
        switch fileExtension {
        case "swift": return .swift
        case "h": return .clangHeader
        case "m": return .objcImpl
        case "storyboard": return .storyboard
        case "xib": return .xib
        case "xcconfig": return .xcconfig
        case "png": return .png
        case "jpeg", "jpg": return .jpeg
        default: return FileType(identifier: String(fileExtension))
        }
    }
}

final class File {
    let url: URL
    let filename: String
    let type: FileType
    
    private var contentLoaded: Bool = false
    private var content: String?
    
    init(url: URL) {
        self.url = url
        self.filename = self.url.lastPathComponent
        self.type = .determine(usingFileName: filename)
    }
    
    func lines() -> Int {
        loadContentIfNeeded()
        guard let content = content else { return 0 }
        return content.components(separatedBy: .newlines).count
    }
    
    func loc() -> Int {
        loadContentIfNeeded()
        guard let content = content else { return 0 }
        
        var count: Int = 0
        var inComment: Bool = false
        for line in content.components(separatedBy: .newlines) {
            if line.hasPrefix("//") ||
                line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                line.trimmingCharacters(in: .controlCharacters).isEmpty {
                continue
            }
            
            if line.hasPrefix("/*") {
                inComment = true
            } else if line.hasSuffix("*/") {
                inComment = false
            } else if !inComment {
                count += 1
            }
        }
        return count
    }
    
    func loadContentIfNeeded(using manager: FileManager = FileManager.default) {
        if contentLoaded { return }
        
        if let data = try? Data(contentsOf: url) {
            content = String(data: data, encoding: .utf8)
        } else {
            content = nil
        }
        contentLoaded = true
    }
    
    static func list(under directoryPath: String, manager: FileManager = .default) -> [File] {
        guard let fileNames = try? manager.contentsOfDirectory(atPath: directoryPath) else {
            Logger.shared.warn("Could not list files under \(directoryPath)")
            return []
        }
        return fileNames.map { File(url: URL(fileURLWithPath: "\(directoryPath)/\($0)")) }
    }
}
