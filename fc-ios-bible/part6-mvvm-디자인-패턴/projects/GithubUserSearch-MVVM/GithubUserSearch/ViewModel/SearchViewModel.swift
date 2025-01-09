//
//  SearchViewModel.swift
//  GithubUserSearch
//
//  Created by 임영택 on 1/9/25.
//

import Foundation
import Combine

final class SearchViewModel {
    let network: NetworkService
    
    var subscriptions = Set<AnyCancellable>()
    
    // 둘 다 가능
//    @Published private(set) var users = [SearchResult]()
    let users: CurrentValueSubject<[SearchResult], Never> = CurrentValueSubject([])
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func search(keyword: String) {
        let resource: Resource<SearchUserResponse> = Resource(
            base: "https://api.github.com/",
            path: "search/users",
            params: ["q": keyword],
            header: ["Content-Type": "application/json"]
        )
        
        network.load(resource)
            .map { $0.items }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
//            .assign(to: \.users, on: self)
            .sink(receiveValue: { [unowned self] result in
                self.users.send(result)
            })
            .store(in: &subscriptions)
    }
}
