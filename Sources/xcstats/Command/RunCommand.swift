import Foundation

struct RunCommand: Command {
    let verb: String = "run"
    let overview: String = "Inspects your Xcode project and prints source code statistics."
    func run() {
        let runPath = FileManager.default.currentDirectoryPath
        
        guard let project = XcodeProject.find(sourceRoot: runPath) else {
            Logger.shared.error("Could not locate .xcodeproj under \(runPath)")
            exit(-1)
        }
        
        Logger.shared.loading("Loading files from \(project.name)")
        let projectFiles = project.enumerateFiles()
        Logger.shared.completed()
        
        let builder = TableOutputBuilder()
        
        builder.append(Statistics(title: "Project", value: .single(project.name)))
        
        Logger.shared.loading("Analyzing Swift source codes")
        builder.append(SwiftFilesStatistics.generate(using: projectFiles))
        Logger.shared.completed()

        Logger.shared.loading("Analyzing Clang source codes")
        builder.append(ClangFileStatistics.generate(using: projectFiles))
        Logger.shared.completed()
        
        Logger.shared.loading("Loading files under source root")
        let sourceRootFiles = File.list(under: runPath)
        Logger.shared.completed()
        Logger.shared.loading("Analyzing package manager dependencies")
        builder.append(PackageManagerStatistics.generate(using: sourceRootFiles))
        Logger.shared.completed()
        
        let lines = builder.build()
        for line in lines {
            Logger.shared.println(line)
        }
        
        Logger.shared.info("Successfully generated project stats 📊")
    }
}
