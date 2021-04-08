//
//  ClassifiedViewModel.swift
//  Classified
//
//  Created by Amir on 07/04/2021.
//

import Foundation

typealias ClassifiedCellViewModelOut = ((ClassifiedCellViewModel.Output) -> Void)

protocol ClassifiedCellViewModelType {
    var output: ClassifiedCellViewModelOut? { get set }
    var price: String { get }
    var name: String { get }
    var date: String { get }
    var data: Data? { get set }
    var imageUrl: String? { get }
    var classified: Classified { get }

    func updateImage(image: Data)
}

class ClassifiedCellViewModel: ClassifiedCellViewModelType {
    //MARK: Properties
    var output: ClassifiedCellViewModelOut?
    var classified: Classified
    var data: Data?
    private let inputFormattor = DateFormatter()
    private let outputFormattor = DateFormatter()

    var price: String {
        classified.price
    }
    
    var name: String {
        classified.name
    }
    
    lazy var date: String = {
        guard let date = inputFormattor.date(from: classified.created_at) else { return classified.created_at }
        return outputFormattor.string(from: date)
    }()
    
    var imageUrl: String? {
        classified.image_urls.first
    }
    
    //MARK: Init
    init(classified: Classified) {
        self.classified = classified
        inputFormattor.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSSS"
        outputFormattor.dateFormat = "yyyy-MM-dd"
    }
    
    func updateImage(image: Data) {
        data = image
        output?(.updateImage(image: image))
    }
    
    //MARK:- Output
    enum Output {
        case updateImage(image: Data)
    }
    
}
