//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Foundation

internal final class RecursiveLock {
    private let lock = NSRecursiveLock()
    private var isEnabled: Bool
    
    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    func sync<T>(action: () -> T) -> T {
        guard isEnabled else {
            return action()
        }
        
        lock.lock()
        defer { lock.unlock() }
        return action()
    }
}
