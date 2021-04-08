//
//  ListViewBuilder.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit
import NetworkModule

/*
    Builer to create view controller
 */
final class ListViewBuilder {
    func build(with delegate: NavigationDelegate) -> UIViewController {
        let storyboard = UIStoryboard(name: "ClassfiedList", bundle: Bundle.main)
        
        let classifiedService = ClassifiedService(network: NetworkService(network: URLSession.shared,
                                                                          vendorId: "",
                                                                          appVersion: ""))
        
        let imageDownloadService = ImageDownloadService(network: NetworkService(network: URLSession.shared,
                                                                          vendorId: "",
                                                                          appVersion: ""))
        
        let viewModel = ClassifiedListViewModel(service: classifiedService, imageDownloadService: imageDownloadService, delegate: delegate)
        let controller = storyboard.instantiateInitialViewController {
            ClassfiedListViewController(coder: $0, viewModel: viewModel)
        }
        
        guard let viewController = controller else {
            fatalError("Failed to load ClassifiedListViewController from storyboard.")
        }

        return viewController
    }
}
