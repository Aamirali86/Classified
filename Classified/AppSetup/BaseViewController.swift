//
//  BaseViewController.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK:- Override
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
