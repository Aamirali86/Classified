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
    var viewModels: [ClassifiedCellViewModelType] { get set }
    var numberOfItems: Int { get }
    
    func fetchClassifiedAds()
    func item(at index: Int) -> ClassifiedCellViewModelType?
    func pauseImageDownload(with url: URL)
    func downloadImage(with url: URL, index: Int)
    func didSelectItem(item: Classified, data: Data)
}

final class ClassifiedListViewModel: ClassfiedListViewModelType {
    //MARK:- Properties
    
    var output: ClassifiedListViewModelOutput?
    var delegate: NavigationDelegate?
    var viewModels: [ClassifiedCellViewModelType] = []
    private let service: ClassifiedServiceType
    private let imageDownloadService: ImageDownloadServiceType
    
    //MARK: Init
    init(service: ClassifiedServiceType,
         imageDownloadService: ImageDownloadServiceType,
         delegate: NavigationDelegate) {
        self.delegate = delegate
        self.service = service
        self.imageDownloadService = imageDownloadService
    }

    var numberOfItems: Int { viewModels.count }
    
    func item(at index: Int) -> ClassifiedCellViewModelType? {
        guard index >= 0 && index < numberOfItems else { return nil }
        return viewModels[index]
    }
    
    func fetchClassifiedAds() {
        service.fetchClassifiedAds { [weak self] result in
            switch result {
            case .success(let ads):
                self?.viewModels = ads.results.map { ClassifiedCellViewModel(classified: $0) }
                self?.output?(.adsFetchSuccess(ads: ads))
            case .failure(let error):
                self?.output?(.adsFetchFailure(error: error))
            }
        }
    }
    
    func downloadImage(with url: URL, index: Int) {
        imageDownloadService.requestImageDownload(url, index) { [weak self] (data, index, error) in
            if let _data = data {
                self?.viewModels[index].updateImage(image: _data)
            }
        }
    }
    
    func pauseImageDownload(with url: URL) {
        imageDownloadService.pauseImageDownloadTask(url)
    }
    
    func didSelectItem(item: Classified, data: Data) {
        delegate?.navigateToDetail(with: item, imageData: data)
    }
    
    //For all of your viewBindings
    enum Output {
        case adsFetchSuccess(ads: ClassifiedList)
        case adsFetchFailure(error: RequestError)
    }
}
