protocol ResultKind {
    associatedtype Success
    associatedtype Failure: Error
    
    var asResult: Result<Success, Failure> { get }
}

extension Result: ResultKind {
    var asResult: Result<Success, Failure> { self }
}

extension Future2 where T: ResultKind {
    func onSuccess(callback: @escaping (T.Success) -> Void) {
        onComplete { value in
            guard case .success(let result) = value.asResult else {
                return
            }
            
            callback(result)
        }
    }
    
    func onFailure(callback: @escaping (T.Failure) -> Void) {
        onComplete { value in
            guard case .failure(let error) = value.asResult else {
                return
            }
            
            callback(error)
        }
    }
}
