//
//  ResultCollectionViewCell.swift
//  InstaSearchView
//
//  Created by 임영택 on 12/11/24.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    /**
     재사용되기 전 호출되는 메서드
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil // 재사용 전 초기화
    }
    
    func configure(_ imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
