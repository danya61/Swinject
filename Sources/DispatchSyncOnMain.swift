@inlinable
@inline(__always)

func dispatchSyncOnMain<T>(executingBlock: @autoclosure @escaping () -> T) -> T {
    
    /// We are to avoid deadlock, at that case should guarantee that there is no nested `sync` calls.
    guard !Thread.isMainThread else { return executingBlock() }
    
    return DispatchQueue.main.sync(execute: executingBlock)
}
