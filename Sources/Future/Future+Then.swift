extension Future2 {
    func then<U>(next: @escaping (T) -> Future2<U>) -> Future2<U> {
        .async { promise in
            self.onComplete { value in
                next(value).onComplete(promise.complete)
            }
        }
    }
    
    func map<U>(transform: @escaping (T) -> U) -> Future2<U> {
        .async { promise in
            self.onComplete { value in
                promise.complete(transform(value))
            }
        }
    }
}
