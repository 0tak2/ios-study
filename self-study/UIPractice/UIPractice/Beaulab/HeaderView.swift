//
//  HeaderView.swift
//  UIPractice
//
//  Created by 임영택 on 2/3/25.
//

import UIKit

class HeaderView: UIView {
    private let halfBackground = UIView()
    private let contentView = UIView()
    var innerView: UIView? {
        didSet {
            setInnerVIew(as: innerView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 440, height: 150)
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = BeaulabColors.primaryColor
        
        halfBackground.translatesAutoresizingMaskIntoConstraints = false
        halfBackground.backgroundColor = BeaulabColors.backgroundDefaultColor
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = BeaulabColors.borderLineColor.cgColor
    }
    
    func layout() {
        addSubview(halfBackground)
        NSLayoutConstraint.activate([
            halfBackground.topAnchor.constraint(equalTo: centerYAnchor),
            halfBackground.leftAnchor.constraint(equalTo: leftAnchor),
            halfBackground.rightAnchor.constraint(equalTo: rightAnchor),
            halfBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 2),
            rightAnchor.constraint(equalToSystemSpacingAfter: contentView.rightAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setInnerVIew(as innerView: UIView?) {
        guard let innerView = innerView else { return }
        
        print("setInnerView \(innerView)")
        
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            innerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

#Preview {
    let headerView = HeaderView()
    let label = UILabel()
    label.text = "Hello, World!"
    headerView.innerView = label
    return headerView
}
