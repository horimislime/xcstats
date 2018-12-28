protocol Command {
    var verb: String { get }
    var overview: String { get }
    func run()
}
