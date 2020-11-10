import XCTest
@testable import Future

class SearchService<T> {
    typealias Future = Future2<Result<T, Error>>
    init(
        performSearch: @escaping (String) -> Future,
        onResult: @escaping (T) -> Void,
        onError: @escaping (Error) -> Void)
    {
        self.performSearch = performSearch
        self.onResult = onResult
        self.onError = onError
    }
    
    let performSearch: (String) -> Future
    let onResult: (T) -> Void
    let onError: (Error) -> Void
    
    
    var currentQuery: String?
    var currentFuture: Future?
    
    func search(query: String) {
        currentFuture?.cancel()
        
        let future = performSearch(query)
        future.onSuccess(callback: onResult)
        future.onFailure(callback: onError)
        
        currentFuture = future
    }
}

enum Some<T> {
    static var value: T { preconditionFailure("Not exist really") }
}


final class FutureTests: XCTestCase {
    func execute(query: String) -> Future2<String> {
        .sync { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                promise.complete("Hello")
            }
        }
    }
    
    func testFuture() {
        let service = SearchService<String>(
            performSearch: Some.value,
            onResult: Some.value,
            onError: Some.value
        )
        
        service.search(query: "")
        
        // Expect no calls to future
    }
}
