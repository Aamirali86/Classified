//
//  ImageDownloadService.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import Foundation
import NetworkModule
import ImageCache

typealias ImageDownloadHandler = (_ data: Data?, _ error: Error?) -> Void

protocol ImageDownloadAPI {
    func requestImageDownload(with imageUrl: URL, completion: @escaping (Result<Data, RequestError>) -> Void)
}

extension NetworkService: ImageDownloadAPI {
    func requestImageDownload(with imageUrl: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {
        requset(imageUrl, completion: completion)
    }
}

protocol ImageDownloadServiceType {
    func requestImageDownload(_ url: URL, handler: @escaping ImageDownloadHandler)
    func pauseImageDownloadTask(_ url: URL)
}

class ImageDownloadService: ImageDownloadServiceType {
    private var completionHandler: ImageDownloadHandler?
    private var network: ImageDownloadAPI
    private var imageCache: CacheManager

    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.dubizzle.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()

    init (network: ImageDownloadAPI, imageCache: CacheManager = CacheManager.shared) {
        self.network = network
        self.imageCache = imageCache
    }

    func requestImageDownload(_ url: URL, handler: @escaping ImageDownloadHandler) {
        completionHandler = handler

        if let cachedImage = imageCache.getItem(url: url.absoluteString) {
            /* check for the cached image for url, if YES then return the cached image */
            completionHandler?(cachedImage, nil)
        } else {
             /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [PGOperation]),
                let operation = operations.filter({$0.imageUrl.absoluteString == url.absoluteString &&
                                                    $0.isFinished == false &&
                                                    $0.isExecuting == true }).first {
                /* Increase the priority.  */
                operation.queuePriority = .veryHigh
            } else {
                /* create a new task to download the image.  */
                let operation = PGOperation(network: network, url: url)
                operation.queuePriority = .high

                operation.downloadHandler = { [weak self] (data, error) in
                    if let data = data {
                        self?.imageCache.set(key: url.absoluteString, item: data)
                    }
                    self?.completionHandler?(data, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }

    // reduce the priority of the operation when image is no longer visible
    func pauseImageDownloadTask(_ url: URL) {
        if let operations = (imageDownloadQueue.operations as? [PGOperation]),
            let operation = operations.filter({$0.imageUrl.absoluteString == url.absoluteString &&
                                                $0.isFinished == false &&
                                                $0.isExecuting == true }).first {
            // Reduce the priority
            operation.queuePriority = .low
        }
    }

    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }

}

class PGOperation: Operation {
    var imageUrl: URL
    var downloadHandler: ImageDownloadHandler?
    private var network: ImageDownloadAPI

    init (network: ImageDownloadAPI, url: URL) {
        self.imageUrl = url
        self.network = network
    }

    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }

        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isFinished: Bool {
        return _finished
    }

    func executing(_ executing: Bool) {
        _executing = executing
    }

    func finish(_ finished: Bool) {
        _finished = finished
    }

    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)

        network.requestImageDownload(with: imageUrl) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                self.downloadHandler?(data, nil)
                self.finish(true)
                self.executing(false)
            case .failure(let error):
                self.downloadHandler?(nil, error)
                self.executing(false)
            }
        }

    }
}
