import Foundation
import SwiftSyntax

class SwiftSyntaxVisitor: SyntaxVisitor {
    enum Target: CaseIterable {
        case enums
        case structs
        case protocols
        case extensions
        case classes
    }
    
    var counter = [Target: Int]()
    
    override init() {
        super.init()
        for target in Target.allCases {
            counter[target] = 0
        }
    }
    
    override func visit(_ node: EnumDeclSyntax) {
        counter[.enums]? += 1
    }
    
    override func visit(_ node: StructDeclSyntax) {
        counter[.structs]? += 1
    }
    
    override func visit(_ node: ProtocolDeclSyntax) {
        counter[.protocols]? += 1
    }
    
    override func visit(_ node: ExtensionDeclSyntax) {
        counter[.extensions]? += 1
    }
    override func visit(_ node: ClassDeclSyntax) {
        counter[.classes]? += 1
    }
}
