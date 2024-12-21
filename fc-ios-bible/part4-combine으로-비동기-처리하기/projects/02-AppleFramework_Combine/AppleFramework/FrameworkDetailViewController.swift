//
//  FrameworkDetailViewController.swift
//  AppleFramework
//
//  Created by joonwon lee on 2022/05/01.
//

import UIKit
import SafariServices
import Combine

class FrameworkDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    private let buttonTapped = PassthroughSubject<AppleFramework, Never>()
    @Published var framework = AppleFramework(name: "Unknown", imageName: "", urlString: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        // input
        buttonTapped
            .receive(on: RunLoop.main)
            .print("[buttonTapped] ")
            .compactMap({ (framework: AppleFramework) in
                URL(string: framework.urlString) // compactMap이므로 nil이면 뒤로 방출되지 않는다
            })
            .sink { [unowned self] (url: URL) in
                let safari = SFSafariViewController(url: url)
                self.present(safari, animated: true)
            }
            .store(in: &subscriptions)
        
        // output
        $framework
            .receive(on: RunLoop.main)
            .print("[selectedFramework] ")
            .sink { [unowned self] framework in
                self.imageView.image = UIImage(named: framework.imageName)
                self.titleLabel.text = framework.name
                self.descriptionLabel.text = framework.description
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func learnMoreTapped(_ sender: Any) {
        buttonTapped.send(framework)
    }
}
