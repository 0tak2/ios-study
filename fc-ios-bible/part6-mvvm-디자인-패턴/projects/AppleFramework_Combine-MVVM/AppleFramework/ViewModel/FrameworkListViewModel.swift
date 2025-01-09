//
//  FrameworkListViewModel.swift
//  AppleFramework
//
//  Created by 임영택 on 1/9/25.
//

import Foundation
import Combine

class FrameworkListViewModel {
    let items: CurrentValueSubject<[AppleFramework], Never>
    let selectedItem: PassthroughSubject<AppleFramework?, Never>
    
    init(items: [AppleFramework]) {
        self.items = CurrentValueSubject(items)
        self.selectedItem = PassthroughSubject()
    }
    
    func didSelect(at indexPath: IndexPath) {
        let item = items.value[indexPath.item]
        selectedItem.send(item)
    }
}
