//
//  HomeFeedCollectionViewCell.swift
//  InstaSearchView
//
//  Created by 임영택 on 12/11/24.
//

import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userThumbnailImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    // 재사용 전 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        userThumbnailImageView.image = nil
        userNameLabel.text = nil
        feedImageView.image = nil
    }

    func configure(_ imageName: String) {
        userThumbnailImageView.image = UIImage(systemName: "pawprint.circle.fill") // TODO: render mode: https://developer.apple.com/documentation/uikit/configuring-and-displaying-symbol-images-in-your-ui#Update-the-rendering-mode-for-a-symbol
        userNameLabel.text = "National Geographic"
        feedImageView.image = UIImage(named: imageName)
    }
}
