//
//  FrameworkDetailViewModel.swift
//  AppleFramework
//
//  Created by 임영택 on 1/9/25.
//

import Foundation
import Combine

final class FrameworkDetailViewModel {
    // Data -> Output
    let framework: CurrentValueSubject<AppleFramework, Never>
    
    // User Action -> Input
    let buttonTapped: PassthroughSubject<AppleFramework, Never>
    
    init(framework: AppleFramework) {
        self.framework = CurrentValueSubject(framework)
        self.buttonTapped = PassthroughSubject()
    }
    
    func learnMoreTapped() {
        buttonTapped.send(framework.value)
    }
}
