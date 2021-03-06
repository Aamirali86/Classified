//
//  BaseCoordinator.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit

/// The `BaseCoordinator` is provides basic/abstract implementation of navigations.
/// it is responsible to manage the presentation logic of view controllers.
/// subclass can override `start` implementation for their specific presentation logic.
class BaseCoordinator<T: UIViewController>: Coordinator {
    let rootViewController: T
    var child: Coordinator?
    weak var parent: Coordinator?
    
    //MARK:- Init
    
    init(rootViewController: T) {
        self.rootViewController = rootViewController
    }
    
    /// show first view controller
    func start() {
        assertionFailure("child class must override it.")
    }
}
