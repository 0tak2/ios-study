//
//  SearchViewController.swift
//  GithubUserSearch
//
//  Created by joonwon lee on 2022/05/25.
//

import UIKit
import Combine
import SafariServices

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private typealias Item = SearchResult
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    
    @Published private var users: [SearchResult] = []
    private var subscriptions = Set<AnyCancellable>()
    
    private let networkService = NetworkService(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedSearchControl()
        
        configureCollectionView()
        
        bind()
    }
    
    private func embedSearchControl() {
        navigationItem.title = "Search"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "유저 이름"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        dataSource = UICollectionViewDiffableDataSource<Int, Item> (collectionView: collectionView, cellProvider: { collectionView, indexPath, result in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return nil }
            
            cell.user.text = result.login
            
            return cell
        })
    }
    
    private func bind() {
        $users
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                self?.applyDataSource(users: users)
            }
            .store(in: &subscriptions)
    }
    
    private func applyDataSource(users: [SearchResult]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(users)
        dataSource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SearchViewController {
    private func fetchSearchResult(of query: String) {
        let resource = Resource<SearchUserResponse>(base: "https://api.github.com",
                                path: "/search/users",
                                params: ["q": query],
                                header: ["content-type": "application/json"])
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .map({ $0.items })
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("request failed. detail: \(error)")
                }
            } receiveValue: { [weak self] results in
                self?.users = results
            }
            .store(in: &subscriptions)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            users = []
            return
        }
        
        print("update search result: \(query)")
        
        fetchSearchResult(of: query)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            users = []
            return
        }
        
        print("search button clicked: \(query)")
        
        fetchSearchResult(of: query)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        let safariVC = SFSafariViewController(url: user.htmlUrl)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}
