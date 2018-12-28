private func main() {
    
    var registry = CommandRegistry(usage: "Usage: xcstats <subcommand>", overview: "Reports code statistics of your Xcode project.")
    registry.register(RunCommand())
    registry.register(VersionCommand())
    
    do {
        try registry.main(RunCommand().verb)
    } catch {
        Logger.shared.error("Failed to print statistics.\n\(error.localizedDescription)")
    }
}

main()
