import Foundation

public enum TaskType {
    case forever
    case disposable
}

public typealias TaskOptionsInfo = [TaskOptionsInfoItem]

public enum TaskOptionsInfoItem {
    case taskType(TaskType)
    case executablePath(String)
    case directoryPath(String)
    case quality(QualityOfService)
}

public struct TaskParsedOptionsInfo {
    public var taskType: TaskType = .disposable
    public var executablePath: String? = nil
    public var directoryPath = detectDirectory()
    public var quality = QualityOfService.default

    public init(_ info: TaskOptionsInfo?) {
        guard let info = info else { return }
        info.forEach {
            switch $0 {
            case .taskType(let value): taskType = value
            case .executablePath(let value): executablePath = value
            case .directoryPath(let value): directoryPath = value
            case .quality(let value): quality = value
            }
        }
    }
}
