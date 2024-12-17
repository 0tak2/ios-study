//
//  QuickFocusCollectionViewCell.swift
//  HeadSpaceFocus
//
//  Created by 임영택 on 12/17/24.
//

import UIKit

class QuickFocusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ item: QuickFocus) {
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
