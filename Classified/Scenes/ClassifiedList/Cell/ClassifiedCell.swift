//
//  ClassifiedCell.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit
import HelpKit

final class ClassifiedCell: UITableViewCell {
    //MARK- Properties
    private var viewModel: ClassifiedCellViewModelType?
    @IBOutlet private var adImage: UIImageView!
    @IBOutlet private var price: UILabel!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var dateAdded: UILabel!

    //MARK- Override
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        adImage.image = nil
        price.text = ""
        name.text = ""
        dateAdded.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    func setupView(with viewModel: ClassifiedCellViewModelType) {
        self.viewModel = viewModel
        adImage.image = UIImage(named: "placeholder")
        price.text = viewModel.price
        name.text = viewModel.name
        dateAdded.text = viewModel.date
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel?.output = { [weak self] output in
            switch output {
            case .updateImage(let image):
                self?.setImage(with: image)
            }
        }
    }
    
    private func setImage(with data: Data) {
        DispatchQueue.main.async {
            self.adImage.image = UIImage(data: data)
        }
    }
    
}

extension ClassifiedCell: Instantiatable {}
