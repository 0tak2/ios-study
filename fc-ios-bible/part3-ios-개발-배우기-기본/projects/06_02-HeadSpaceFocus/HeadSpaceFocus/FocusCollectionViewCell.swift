//
//  FocusCollectionViewCell.swift
//  HeadSpaceFocus
//
//  Created by 임영택 on 12/15/24.
//

import UIKit

class FocusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .systemIndigo
        self.contentView.layer.cornerRadius = 10
    }
    
    func configure(_ item: Focus) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        thumbnailImageView.image = UIImage(systemName: item.imageName)?
            .withRenderingMode(.alwaysOriginal) // .alwaysOriginal -> 실제 컬러
                                                // .alwaysTemplate -> 원래 컬러 무시하고 쉐입만 가져옴
    }
}
