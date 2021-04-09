//
//  ClassifiedListViewModelTest.swift
//  ClassifiedTests
//
//  Created by Amir on 09/04/2021.
//

import Foundation
import NetworkModule
import XCTest

@testable import Classified

final class ClassifiedListViewModelTest: XCTestCase {
    var viewModel: ClassfiedListViewModelType!
    var imageDownloadService: MockImageDownloadService!

    override func setUp() {
        super.setUp()
        
        let classifiedService = MockClassifiedService()
        imageDownloadService = MockImageDownloadService()
        let coordinator = MockCoordinator()
        
        viewModel = ClassifiedListViewModel(service: classifiedService,
                                            imageDownloadService: imageDownloadService,
                                            delegate: coordinator)
    }
    
    func testNumberOfItems() {
        viewModel.output = { output in
            switch output {
            case .adsFetchSuccess(let ads):
                XCTAssertEqual(self.viewModel.numberOfItems, 3)
                XCTAssertEqual(ads.results.count, 3)
            default:
                break
            }
        }
        viewModel.fetchClassifiedAds()
    }
    
    func testItemAtIndex() {
        viewModel.fetchClassifiedAds()
        let childViewModel = viewModel.item(at: 0)
        XCTAssertNotNil(childViewModel)
        XCTAssertEqual(childViewModel!.name, "Notebook")
        XCTAssertEqual(childViewModel!.price, "AED 5")
    }
    
    func testPauseImageDownload() {
        guard let url = URL(string: "https:google.com") else { return }
        
        XCTAssertFalse(imageDownloadService.imageDownloadPaused)
        viewModel.pauseImageDownload(with: url)
        XCTAssertTrue(imageDownloadService.imageDownloadPaused)
    }
    
    func testDownloadImage() {
        guard let url = URL(string: "https:google.com") else { return }
        
        viewModel.fetchClassifiedAds()
        viewModel.downloadImage(with: url, index: 0)
        let childViewModel = viewModel.viewModels[0]
        XCTAssertNotNil(childViewModel.data)
    }
    
}

final class MockClassifiedService: ClassifiedServiceType {
    var isFetchSuccess = true
    
    func fetchClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void) {
        if isFetchSuccess {
            completion(.success(ClassifiedList(results: [
                Classified.fake(created_at: "2019-02-24 04:04:17.566515", price: "AED 5", name: "Notebook"),
                Classified.fake(created_at: "2019-02-23 07:56:26.686128", price: "AED 500", name: "Glasses"),
                Classified.fake(created_at: "2019-02-27 11:21:59.983164", price: "AED 50", name: "monitor")
            ])))
        } else {
            completion(.failure(RequestError.noResponse))
        }
    }
}

final class MockImageDownloadService: ImageDownloadServiceType {
    var imageDownloadPaused = false
    func requestImageDownload(_ url: URL, _ index: Int, handler: @escaping ImageDownloadHandler) {
        handler(Data(count: 1), 0, nil)
    }
    
    func pauseImageDownloadTask(_ url: URL) {
        imageDownloadPaused = true
    }
}

class MockCoordinator: NavigationDelegate {
    func navigateToDetail(with item: Classified, imageData: Data) {
        
    }
}
