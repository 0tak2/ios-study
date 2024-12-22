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
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    @Published private var results: [SearchResult] = []
    private var subscriptions = Set<AnyCancellable>()
    
    private let networkService = NetworkService(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "유저 이름"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
        // Collection View
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        dataSource = UICollectionViewDiffableDataSource<Int, SearchResult> (collectionView: collectionView, cellProvider: { collectionView, indexPath, result in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return UICollectionViewCell() }
            
            cell.user.text = result.login
            
            return cell
        })
        
        bind()
    }
    
    private func bind() {
        $results
            .receive(on: RunLoop.main)
            .sink { [weak self] results in
                self?.applyDataSource(results: results)
            }
            .store(in: &subscriptions)
    }
    
    private func applyDataSource(results: [SearchResult]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
        snapshot.appendSections([0])
        snapshot.appendItems(results)
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
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("request failed. detail: \(error)")
                }
            } receiveValue: { [weak self] responseData in
                self?.results = responseData.items
            }
            .store(in: &subscriptions)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            results = []
            return
        }
        
        print("update search result: \(query)")
        
        fetchSearchResult(of: query)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            results = []
            return
        }
        
        print("search button clicked: \(query)")
        
        fetchSearchResult(of: query)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = results[indexPath.item]
        let safariVC = SFSafariViewController(url: user.htmlUrl)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}
