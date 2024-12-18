//
//  UIView+PinnedSubview.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import UIKit

extension UIView {
    /**
     위에 붙어있는 뷰를 추가
     */
    func addPinnedSubview(_ subview: UIView, height: CGFloat? = nil,
                          insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        addSubview(subview)
        
        // 시스템에 의해 오토 레이아웃되는 것을 방지
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom).isActive = true
        
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
