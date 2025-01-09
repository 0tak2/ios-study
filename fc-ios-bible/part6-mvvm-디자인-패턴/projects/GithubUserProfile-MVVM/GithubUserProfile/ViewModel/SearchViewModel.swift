//
//  SearchViewModel.swift
//  GithubUserProfile
//
//  Created by 임영택 on 1/9/25.
//

import Foundation
import Combine

final class SearchViewModel {
    let network: NetworkService
    
    var subscriptions = Set<AnyCancellable>()
    
    let selectedUser: CurrentValueSubject<UserProfile?, Never>
    
    var name: String {
        selectedUser.value?.name ?? "n/a"
    }
    
    var login: String {
        selectedUser.value?.login ?? "n/a"
    }
    
    var follower: String {
        if let follower = selectedUser.value?.followers {
            return "followers: \(follower)"
        }
        return ""
    }
    
    var following: String {
        if let following = selectedUser.value?.following {
            return "followings: \(following)"
        }
        return ""
    }
    
    var thumbnailImage: URL? {
        selectedUser.value?.avatarUrl
    }
    
    init(network: NetworkService, selectedUser: UserProfile?) {
        self.network = network
        self.selectedUser = CurrentValueSubject(selectedUser)
    }
    
    func search(keyword: String) {
        let resource = Resource<UserProfile>(base: "https://api.github.com/", path: "users/\(keyword)", params: [:], header: ["Content-Type": "application/json"])
        
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.selectedUser.send(nil)
                    print("error: \(error)")
                case .finished: break
                }
            } receiveValue: { [unowned self] user in
                self.selectedUser.send(user)
            }.store(in: &subscriptions)
    }
}
