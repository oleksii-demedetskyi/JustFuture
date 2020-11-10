class FutureContext<T> {
    private enum State {
        case initial
        case completed(T)
        case cancelled
    }
    
    private var state: State = .initial {
        didSet {
            switch (oldValue, state) {
                case (.initial, .cancelled): break
                case (.initial, .completed(let value)):
                    for callback in callbacks {
                        callback(value)
                    }
                
                callbacks = []
                
                default: preconditionFailure("Unsupported transition")
            }
        }
    }
    
    private var callbacks: [(T) -> Void] = []
    
    func complete(with value: T) {
        state = .completed(value)
    }
    
    func onComplete(callback: @escaping (T) -> Void) {
        switch state {
            case .initial: callbacks.append(callback)
            case .completed(let value): callback(value)
            case .cancelled: break
        }
    }
    
    func cancel() {
        state = .cancelled
    }
}
