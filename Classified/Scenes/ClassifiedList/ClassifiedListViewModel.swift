//
//  ClassifiedListViewModel.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import Foundation
import NetworkModule

typealias ClassifiedListViewModelOutput = ((ClassifiedListViewModel.Output) -> Void)

protocol ClassfiedListViewModelType {
    var output: ClassifiedListViewModelOutput? { get set }
    var numberOfItems: Int { get }

    func fetchClassifiedAds()
    func item(at index: Int) -> Classified?
    func pauseImageDownload(with url: URL)
    func downloadImage(with url: URL, handler: @escaping ImageDownloadHandler)
}

final class ClassifiedListViewModel: ClassfiedListViewModelType {
    private var ads: [Classified] = []
    var output: ClassifiedListViewModelOutput?
    private let service: ClassifiedServiceType
    private let imageDownloadService: ImageDownloadServiceType

    // MARK: Init
    init(service: ClassifiedServiceType, imageDownloadService: ImageDownloadServiceType) {
        self.service = service
        self.imageDownloadService = imageDownloadService
    }

    var numberOfItems: Int { ads.count }

    func item(at index: Int) -> Classified? {
        guard index > 0 && index < numberOfItems else { return nil }
        return ads[index]
    }

    func fetchClassifiedAds() {
        service.fetchClassifiedAds { [weak self] result in
            switch result {
            case .success(let ads):
                self?.ads = ads.results
                self?.output?(.adsFetchSuccess(ads: ads))
            case .failure(let error):
                self?.output?(.adsFetchFailure(error: error))
            }
        }
    }

    func downloadImage(with url: URL, handler: @escaping ImageDownloadHandler) {
        imageDownloadService.requestImageDownload(url, handler: handler)
    }

    func pauseImageDownload(with url: URL) {
        imageDownloadService.pauseImageDownloadTask(url)
    }

    // For all of your viewBindings
    enum Output {
        case adsFetchSuccess(ads: ClassifiedList)
        case adsFetchFailure(error: RequestError)
    }
}
