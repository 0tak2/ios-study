//
//  SearchViewController.swift
//  GithubUserSearch
//
//  Created by joonwon lee on 2022/05/25.
//

import UIKit
import Combine
import Kingfisher

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    private let networkService = NetworkService(configuration: .default)
    
    private var subscriptions = Set<AnyCancellable>()
    @Published private(set) var user: UserProfile?
    
    // ==== 필요한 것 ====
    // SearchControl
    // 네트워크 작업
    // UserProfile
    // bind
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedSearchControl()
        bind()
    }
    
    private func setupUI() {
        thumbnail.layer.cornerRadius = 80 // 160*160이므로 그 절반인 80을 지정해 완전한 원형으로 만들기
    }
    
    private func embedSearchControl() {
        self.navigationItem.title = "Search"
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "유저 이름을 입력해주세요"
        searchController.searchResultsUpdater = self // 텍스트 변경될 때마다의 처리를 delegate
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
    }
    
    private func bind() {
        $user.receive(on: RunLoop.main)
            .sink { [weak self] userProfile in
                self?.updateUI(profile: userProfile)
            }
            .store(in: &subscriptions)
    }
    
    private func updateUI(profile: UserProfile?) {
        guard let profile = profile else {
            let keyword = self.navigationItem.searchController?.searchBar.text
            
            self.nameLabel.text = "\(keyword ?? "") 유저가 없습니다."
            self.loginLabel.text = ""
            self.followerLabel.text = ""
            self.followingLabel.text = ""
            self.thumbnail.image = nil
            
            return
        }
        
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.login
        self.followerLabel.text = "followers: \(profile.followers)"
        self.followingLabel.text = "following: \(profile.following)"
        
        // image url -> image
        self.thumbnail.kf.setImage(with: profile.avatarUrl) // Kingfisher
    }
}

extension UserProfileViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        print("updateSearchResults: \(String(describing: query))")
    }
    
    
}

extension UserProfileViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked: \(String(describing: searchBar.text))")
        
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        
        let resource = Resource<UserProfile>(base: "https://api.github.com",
                                             path: "/users/\(query)",
                                             params: [:],
                                             header: ["content-type": "application/json"])
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("request failed: \(error)")
                    self?.user = nil
                }
            } receiveValue: { [weak self] profile in
                self?.updateUI(profile: profile)
            }
            .store(in: &subscriptions)
    }
}
