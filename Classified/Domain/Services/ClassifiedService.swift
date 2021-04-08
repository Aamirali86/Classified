//
//  ClassifiedService.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import Foundation
import NetworkModule

protocol ClassifiedAPI {
    func requestClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void)
}

protocol ClassifiedServiceType {
    /// Fetch currently available classified ads
    func fetchClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void)
}

final class ClassifiedService: ClassifiedServiceType {
    private let network: ClassifiedAPI
    
    init(network: ClassifiedAPI) {
        self.network = network
    }
    
    func fetchClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void) {
        network.requestClassifiedAds(completion: completion)
    }
}

extension NetworkService: ClassifiedAPI {
    func requestClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void) {
        let resource = ClassifiedRequest()
        request(resource, completion: completion)
    }
}
