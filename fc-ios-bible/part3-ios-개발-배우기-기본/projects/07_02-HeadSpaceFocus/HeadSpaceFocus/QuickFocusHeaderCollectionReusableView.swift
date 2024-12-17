//
//  QuickFocusHeaderCollectionReusableView.swift
//  HeadSpaceFocus
//
//  Created by 임영택 on 12/17/24.
//

import UIKit

class QuickFocusHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
