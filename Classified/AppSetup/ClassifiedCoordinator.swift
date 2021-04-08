//
//  ClassifiedCoordinator.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit

protocol NavigationDelegate {
    func navigateToDetail(with item: Classified, imageData: Data)
}

final class ClassifiedCoordinator: BaseCoordinator<UINavigationController> {
    override func start() {
        let listVC = ListViewBuilder().build(with: self)
        rootViewController.pushViewController(listVC, animated: true)
    }
    
}

extension ClassifiedCoordinator: NavigationDelegate {
    func navigateToDetail(with item: Classified, imageData: Data) {
        let detailVC = DetailViewBuilder().build(with: item, imageData: imageData)
        rootViewController.pushViewController(detailVC, animated: true)
    }
}
