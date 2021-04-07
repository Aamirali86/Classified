import Foundation

public struct CacheManager {
    public static let shared = CacheManager()
    private let queue = DispatchQueue(label: "dictionary", attributes: .concurrent)
    private var cached = [String: Data]()

    private init() {}

    public mutating func set(key: String, item: Data) {
        var cachedData = cached[key]
        if cachedData == nil {
            queue.sync {
                cachedData = item
                cached[key] = cachedData
            }
        }
    }

    public func getItem(url: String) -> Data? {
        var data: Data?
        queue.sync {
            data = cached[url]
        }
        return data
    }

    public mutating func clearAllCache() {
        cached.removeAll()
    }

}
