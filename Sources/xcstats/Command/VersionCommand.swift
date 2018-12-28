struct VersionCommand: Command {
    let verb: String = "version"
    let overview: String = "Prints version of xcstats."
    func run() {
        Logger.shared.println("xcstats \(Version.current.value)")
    }
}
