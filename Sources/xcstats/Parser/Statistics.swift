import Foundation
import SwiftSyntax

struct Statistics {
    
    struct PairValue {
        let title: String
        let value: String
    }
    
    enum Value {
        case single(String)
        case multi([PairValue])
    }
    
    let title: String
    let value: Value
}

protocol StatisticsGenerator {
    static func generate(using files: [File]) -> Statistics
}

enum ClangFileStatistics: StatisticsGenerator {
    static func generate(using files: [File]) -> Statistics {
        let clangHeaders = files.filter { $0.type == .clangHeader }
        let objcImpls = files.filter { $0.type == .objcImpl }
        
        if clangHeaders.isEmpty && objcImpls.isEmpty {
            return Statistics(title: "Clang", value: .single("None"))
        }

        let (lines, loc) = (clangHeaders + objcImpls).reduce((0, 0)) { (prev: (Int, Int), file: File) -> (Int, Int) in
            return (prev.0 + file.lines(), prev.1 + file.loc())
        }
        
        return Statistics(
            title: "Clang",
            value: .multi([
                Statistics.PairValue(title: "Lines", value: "\(lines)"),
                Statistics.PairValue(title: "LOC", value: "\(loc)"),
                Statistics.PairValue(title: "C Headers", value: "\(clangHeaders.count)"),
                Statistics.PairValue(title: "Objective-C", value: "\(objcImpls.count)"),
                ])
        )
    }
}

enum SwiftFilesStatistics: StatisticsGenerator {

    static func generate(using files: [File]) -> Statistics {
        
        let syntaxVisitor = SwiftSyntaxVisitor()
        
        let swiftFiles = files.filter { $0.type == .swift }
        
        for file in swiftFiles {
            do {
                let syntax = try SyntaxTreeParser.parse(file.url)
                syntaxVisitor.visit(syntax)
            } catch {
                Logger.shared.warn("Failed to parse Swift source \(file.url.absoluteString)\n\(error.localizedDescription)")
            }
        }
        
        let (lines, loc) = swiftFiles.reduce((0, 0)) { (prev: (Int, Int), file: File) -> (Int, Int) in
            return (prev.0 + file.lines(), prev.1 + file.loc())
        }
        
        var results: [Statistics.PairValue] = [
            Statistics.PairValue(title: "Files", value: "\(swiftFiles.count)"),
            Statistics.PairValue(title: "Lines", value: "\(lines)"),
            Statistics.PairValue(title: "LOC", value: "\(loc)")
        ]
        
        results += syntaxVisitor.counter
            .filter({ $1 > 0 })
            .map { (type: SwiftSyntaxVisitor.Target, value: Int) -> Statistics.PairValue in
                
                let valueString = "\(value)"
                switch type {
                case .enums:
                    return Statistics.PairValue(title: "Enum", value: valueString)
                case .structs:
                    return Statistics.PairValue(title: "Struct", value: valueString)
                case .protocols:
                    return Statistics.PairValue(title: "Protocol", value: valueString)
                case .extensions:
                    return Statistics.PairValue(title: "Extension", value: valueString)
                case .classes:
                    return Statistics.PairValue(title: "Class", value: valueString)
                }
        }
        return Statistics(title: "Swift", value: .multi(results))
    }
}

enum PackageManagerStatistics: StatisticsGenerator {
    
    static func generate(using files: [File]) -> Statistics {
        
        var stats: [Statistics.PairValue] = []
        
        if let file = files.filter({ $0.type == .cartfile }).first, let cartfile = Cartfile.from(fileURL: file.url) {
            stats.append(Statistics.PairValue(title: "Carthage", value: "\(cartfile.dependencies.count) dependencies"))
        }
        
        if let file = files.filter({ $0.type == .podfile }).first, let podfile = Podfile.from(fileURL: file.url) {
            stats.append(Statistics.PairValue(title: "CocoaPods", value: "\(podfile.dependencies.count) dependencies"))
        }
        
        if let file = files.filter({ $0.type == .packageSwift }).first, let packageFile = SwiftPackageDescription.from(fileURL: file.url) {
            stats.append(Statistics.PairValue(title: "Swift PM", value: "\(packageFile.dependencyCount) dependencies"))
        }
        
        if stats.isEmpty {
            return Statistics(title: "Package Manager", value: .single("N/A"))
        } else {
            return Statistics(title: "Package Manager", value: .multi(stats))
        }
    }
}
