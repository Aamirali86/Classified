//
//  DetailViewBuilder.swift
//  Classified
//
//  Created by Amir on 08/04/2021.
//

import UIKit

final class DetailViewBuilder {
    func build(with classified: Classified, imageData: Data) -> UIViewController {
        let storyboard = UIStoryboard(name: "ClassifiedDetail", bundle: Bundle.main)
        let viewModel = DetailViewModel(data: imageData, withItem: classified);
        let controller = storyboard.instantiateInitialViewController {
            DetailViewController(coder: $0, withVM: viewModel)
        }
        
        guard let viewController = controller else {
            fatalError("Failed to load ClassifiedDetailViewController from storyboard.")
        }

        return viewController
    }
}
