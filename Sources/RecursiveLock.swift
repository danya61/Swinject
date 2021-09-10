//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Foundation

/// Honestly, no locks here
internal final class RecursiveLock {
    func sync<T>(action: () -> T) -> T { action() }
}
