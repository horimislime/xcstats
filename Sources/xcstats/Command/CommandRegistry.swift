import Foundation
import Utility

struct CommandRegistry {
    
    private let parser: ArgumentParser
    private var commands: [Command] = []
    
    init(usage: String, overview: String) {
        self.parser = ArgumentParser(usage: usage, overview: overview)
    }
    
    mutating func register(_ command: Command) {
        _ = parser.add(subparser: command.verb, overview: command.overview)
        commands.append(command)
    }
    
    func main(_ verb: String) throws {
        
        let arguments = try parse()
        
        if let subCommandName = arguments.subparser(parser) {
            commands
                .first(where: { $0.verb == subCommandName })!
                .run()
        } else {
            commands
                .first(where: { $0.verb == verb })!
                .run()
        }
    }
    
    private func parse() throws -> ArgumentParser.Result {
        let args = ProcessInfo.processInfo.arguments.dropFirst()
        return try parser.parse(Array(args))
    }
}
