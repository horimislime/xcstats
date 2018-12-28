import Foundation
import SwiftSyntax

struct SwiftPackageDescription {
    
    let dependencyCount: Int
    
    static func from(fileURL url: URL) -> SwiftPackageDescription? {

        guard let syntax = try? SyntaxTreeParser.parse(url) else { return nil }
        let visitor = PackageSwiftSyntaxVisitor()
        visitor.visit(syntax)
        if visitor.isPackageDescription {
            return SwiftPackageDescription(dependencyCount: visitor.dependencyCount)
        }
        return nil
    }
}

private final class PackageSwiftSyntaxVisitor: SyntaxVisitor {
    
    var isPackageDescription: Bool = false
    var dependencyCount: Int = 0
    
    override func visit(_ node: ImportDeclSyntax) {
        if node.path.description == "PackageDescription" {
            isPackageDescription = true
        }
    }
    
    override func visit(_ node: ArrayExprSyntax) {
        if let syntax = node.parent as? FunctionCallArgumentSyntax, syntax.label?.text == "dependencies" {
            dependencyCount = node.elements.count
        }
    }
}
