//
//  ClassifiedCell.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import UIKit
import HelpKit

final class ClassifiedCell: UITableViewCell {
    @IBOutlet private var adImage: UIImageView!
    @IBOutlet private var price: UILabel!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var dateAdded: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    func setupView(with ad: Classified) {
        adImage.image = UIImage(named: "placeholder")
        price.text = ad.price
        name.text = ad.name
        dateAdded.text = ad.created_at
    }
    
    func setImage(with data: Data) {
        DispatchQueue.main.async {
            self.adImage.image = UIImage(data: data)
        }
    }
    
}

extension ClassifiedCell: Instantiatable {}
