//
//  BeaulabMyPageViewController.swift
//  UIPractice
//
//  Created by 임영택 on 2/3/25.
//

import UIKit

class BeaulabMyPageViewController: UIViewController {
    let headerView = HeaderView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "마이페이지"

        style()
        layout()
    }
    
    private func style() {
        view.backgroundColor = BeaulabColors.primaryColor
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = BeaulabColors.backgroundDefaultColor
    }
    
    private func layout() {
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 128),
        ])
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

#Preview {
    BeaulabMyPageViewController()
}
