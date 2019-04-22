import Foundation

public protocol Task: class {
    var taskArguments: [String] { get }
    var identifier: String { get }
    var option: TaskParsedOptionsInfo { get }
    var onError: Delegate<Error, Void> { get }
    var process: Process? { get set }
}

extension Task {
    public var isRunning: Bool {
        return process?.isRunning ?? false
    }
}

extension Task {
    public func run() {
        let process = Process()
        process.qualityOfService = option.quality
        process.arguments = taskArguments
        
        //setup and run
        switch option.taskType {
        case .forever:
            process.terminationHandler = { p in
                self.run()
            }
        default: break
        }
        if #available(OSX 10.13, *) {
            if let path = option.executablePath {
                process.executableURL = URL(fileURLWithPath: path)
            } else {
                process.executableURL = nil
            }
            process.currentDirectoryURL = URL(fileURLWithPath: option.directoryPath, isDirectory: true)
            do {
                try process.run()
            } catch {
                // onError
                onError.call(error)
            }
        } else {
            process.launchPath = option.executablePath
            process.currentDirectoryPath = option.directoryPath
            process.launch()
        }
        
        //reset process
        self.process = process
    }
    
    public func interrupt() {
        process?.interrupt()
    }
    
    public func resume() -> Bool {
        return process?.resume() ?? false
    }
    
    public func suspend() -> Bool {
        return process?.suspend() ?? false
    }
    
    public func terminate() {
        process?.terminate()
    }
}
