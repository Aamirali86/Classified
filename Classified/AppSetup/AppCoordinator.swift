//
//  AppCoordinator.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit

/// `AppCoordinator` is responsible to manage transition at windows level.
final class AppCoordinator: BaseCoordinator<UINavigationController> {
    //MARK:- Init
    
    private let window: UIWindow
    
    //MARK:- Init
    
    init(window: UIWindow) {
        self.window = window
        super.init(rootViewController: .init())
    }
    
    //MARK:- Override
    
    override func start() {
        let coordinator = ClassifiedCoordinator(rootViewController: rootViewController)
        startChild(coordinator)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
