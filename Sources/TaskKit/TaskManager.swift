import Foundation

public class TaskManager {
    public var shared = TaskManager()
    private var tasks: [String: Task] = [:]
    private var lock: Lock = Lock()
    private init() {}

    public func addTask(_ task: Task) {
        lock.lock()
        defer { lock.unlock() }
        tasks[task.identifier] = task
    }

    public func removeTask(with identifier: String) {
        lock.lock()
        defer { lock.unlock() }
        let task = tasks.removeValue(forKey: identifier)
        task?.terminate()
    }
    
    public func task(forKey key: String) -> Task? {
        lock.lock()
        defer { lock.unlock() }
        return tasks[key]
    }
    
    public func fireAll() {
        lock.lock()
        let taskValues = tasks.values
        defer { lock.unlock() }
        taskValues.forEach { $0.run() }
    }
    
    public func currentTasks() -> [Task] {
        lock.lock()
        let taskValues = tasks.values
        defer { lock.unlock() }
        return taskValues.sorted { $0.identifier > $1.identifier }
    }
}
