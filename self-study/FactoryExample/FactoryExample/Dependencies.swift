//
//  Dependencies.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import FactoryKit

extension Container {
    var adviceRepository: Factory<AdviceRepository> {
        Factory(self) { AdviceRepository() }
    }
    
    var adviceService: Factory<AdviceService> {
        Factory(self) {
            AdviceService(repository: self.adviceRepository())
        }
    }
}
