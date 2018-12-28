import Basic
import Foundation

final class Logger {
    
    static let shared: Logger = Logger()
    
    private let terminalController: TerminalController
    private let queue: DispatchQueue
    private var loading: Bool = true
    private var loadingTask: DispatchWorkItem?
    
    private init() {
        guard let stdout = stdoutStream as? LocalFileOutputByteStream else {
            preconditionFailure()
        }
        terminalController = TerminalController(stream: stdout)!
        queue = DispatchQueue(label: "com.horimislime.xcstats", qos: .background)
    }
    
    func loading(_ message: String) {
        terminalController.write(message)
        loadingTask = DispatchWorkItem { [weak self] in
            guard let s = self else { return }
            while let task = s.loadingTask, !task.isCancelled {
                s.terminalController.write(".")
                sleep(1)
            }
        }
        queue.async(execute: loadingTask!)
    }
    
    func println(_ message: String) {
        terminalController.write(message)
        terminalController.endLine()
    }
    
    func completed() {
        loading = false
        loadingTask?.cancel()
        terminalController.write(" completed.")
        terminalController.endLine()
    }
    
    func info(_ message: String) {
        terminalController.endLine()
        terminalController.write(message, inColor: .green, bold: true)
        terminalController.endLine()
    }
    
    func warn(_ message: String) {
        terminalController.endLine()
        terminalController.write(message, inColor: .yellow, bold: true)
        terminalController.endLine()
    }
    
    func error(_ message: String) {
        terminalController.endLine()
        terminalController.write(message, inColor: .red, bold: true)
        terminalController.endLine()
    }
}
