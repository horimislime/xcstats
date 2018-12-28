import Foundation
import PathKit
import xcodeproj

struct XcodeProject {
    
    let sourceRootPath: Path
    let name: String
    private let proj: XcodeProj
    
    private init(sourceRootPath: String, projFileName: String) {
        self.sourceRootPath = Path(sourceRootPath)
        self.name = projFileName
        self.proj = try! XcodeProj(pathString: "\(sourceRootPath)/\(projFileName)")
    }
    
    static func find(sourceRoot: String) -> XcodeProject? {
        
        guard let filePaths = try? FileManager.default.contentsOfDirectory(atPath: sourceRoot) else {
            return nil
        }
        
        let projFiles = filePaths.filter({ $0.split(separator: ".").last == "xcodeproj" })
        
        if projFiles.isEmpty {
            return nil
        }
        
        if projFiles.count >= 2 {
            Logger.shared.error("Multiple project files are found.")
            projFiles.forEach { Logger.shared.error($0) }
            preconditionFailure()
        }
        
        return XcodeProject(sourceRootPath: sourceRoot, projFileName: projFiles[0])
    }
    
    func enumerateFiles() -> [File] {
        return proj.pbxproj.fileReferences
            .filter({
                $0.sourceTree != .sourceRoot &&
                    $0.sourceTree != .buildProductsDir &&
                    $0.sourceTree != .sdkRoot &&
                    $0.sourceTree != .developerDir
            
            }).compactMap { ref -> File? in
                guard let fullPath = (try? ref.fullPath(sourceRoot: sourceRootPath))??.string else {
                    return nil
                }
                if fullPath == sourceRootPath.string && ref.sourceTree == .group { return nil }
                let relativePath = fullPath.replacingOccurrences(of: sourceRootPath.string, with: "")
                if relativePath.components(separatedBy: "/").filter({ $0.hasPrefix(".") }).count > 0 {
                    return nil
                }
                return File(url: URL(fileURLWithPath: fullPath))
            }
    }
}
