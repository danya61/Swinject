//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Foundation

internal final class RecursiveLock {
    
    private let lockingMechanism: Synchronizable
    
    init(isGCDSolution: Bool) {
        lockingMechanism = isGCDSolution
            ? DispatchQueueSolution()
            : NSRecursiveLockSolution()
    }
    
    func sync<T>(action: () -> T) -> T {
        lockingMechanism.sync(action: action)
    }
    
}

protocol Synchronizable {
    func sync<T>(action: () -> T) -> T
}

final class NSRecursiveLockSolution: Synchronizable {
    
    private let lock = NSRecursiveLock()

    func sync<T>(action: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return action()
    }
    
}

final class DispatchQueueSolution: Synchronizable {
    
    enum HelperQueue {
        
        static let key = DispatchSpecificKey<String>()
        static let name = "com.swinject_city.resolve_queue"
        
        static let queue = DispatchQueue(label: Self.name)
        static var onceToken = true
        
    }
    
    func sync<T>(action: () -> T) -> T {
        if HelperQueue.onceToken {
            HelperQueue.queue.setSpecific(key: HelperQueue.key, value: HelperQueue.name)
            HelperQueue.onceToken = false
        }
        
        if DispatchQueue.getSpecific(key: HelperQueue.key) == HelperQueue.name {
            return action()
        } else {
            return HelperQueue.queue.sync(execute: action)
        }
    }
    
    
}
