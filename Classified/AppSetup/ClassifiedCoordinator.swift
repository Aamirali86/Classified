//
//  ClassifiedCoordinator.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit

final class ClassifiedCoordinator: BaseCoordinator<UINavigationController> {
    override func start() {
        let listVC = ListViewBuilder().build()
        rootViewController.pushViewController(listVC, animated: true)
    }
}
