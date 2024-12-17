//
//  FrameworkDetailViewController.swift
//  AppleFramework
//
//  Created by 임영택 on 12/17/24.
//

import UIKit
import SafariServices

class FrameworkDetailViewController: UIViewController {
    var framework: AppleFramework = .init(name: "Unknown", imageName: "", urlString: "", description: "")
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContents()
    }
    
    func updateContents() {
        imageView.image = UIImage(named: framework.imageName)
        titleLabel.text = framework.name
        descriptionLabel.text = framework.description
    }
    
    @IBAction func learnMoreTapped(_ sender: Any) {
        guard let url = URL(string: framework.urlString) else {
            return
        }
        
        let safari = SFSafariViewController(url: url)
        self.present(safari, animated: true)
    }
}
