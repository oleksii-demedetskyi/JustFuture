struct Future2<T> {
    let onComplete: (@escaping (T) -> Void) -> Void
    let cancel: () -> Void
}

struct Promise2<T> {
    let complete: (T) -> Void
    
}

extension Future2 {
    static func sync(payload: (Promise2<T>) -> Void) -> Self {
        let context = FutureContext<T>()
        
        let future = Future2(
            onComplete: context.onComplete(callback:),
            cancel: context.cancel)
        
        let promise = Promise2(complete: context.complete(with: ))
        
        payload(promise)
        
        return future
    }

    static func async(payload: (Promise2<T>) -> Void,
         line: Int = #line,
         function: StaticString = #function,
         file: StaticString = #file) -> Self
    {
        let queue = DispatchQueue(label: "Future from \(file) in \(function) at \(line)")
        
        let future = Self.sync { promise in
            payload(promise.moveToQueue(queue: queue))
        }
        
        return future.moveToQueue(queue: queue)
    }
}

import Dispatch
extension Future2 {
    func moveToQueue(queue: DispatchQueue) -> Self {
        Self(
            onComplete: queue.wrap(block: self.onComplete),
            cancel: queue.wrap(block: self.cancel)
        )
    }
}

extension Promise2 {
    func moveToQueue(queue: DispatchQueue) -> Self {
        Self(
            complete: queue.wrap(block: self.complete)
        )
    }
}

extension DispatchQueue {
    func wrap<T>(block: @escaping (T) -> Void) -> (T) -> Void {
        return { value in
            self.async {
                block(value)
            }
        }
    }
    
    func wrap(block: @escaping () -> Void) -> () -> Void {
        return {
            self.async {
                block()
            }
        }
    }
}
