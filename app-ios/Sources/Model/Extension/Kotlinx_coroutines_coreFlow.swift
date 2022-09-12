import appioscombined

class FlowCollector<T>: Kotlinx_coroutines_coreFlowCollector {
    let callback: (T) -> Void

    init(callback: @escaping (T) -> Void) {
        self.callback = callback
    }

    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        if let value = value as? T {
            callback(value)
        }
        completionHandler(nil)
    }
}

public extension Kotlinx_coroutines_coreFlow {
    func stream<T>() -> AsyncThrowingStream<T, Error> {
        return AsyncThrowingStream { [weak self] continuation in
            DispatchQueue.main.async {
                self?.collect(collector: FlowCollector<T>(callback: { value in
                    continuation.yield(value)
                }), completionHandler: { error in
                    if let error = error {
                        continuation.finish(throwing: error)
                    } else {
                        continuation.finish()
                    }
                })
            }
        }
    }
}
