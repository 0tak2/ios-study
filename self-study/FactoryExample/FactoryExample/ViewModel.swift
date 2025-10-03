//
//  ViewModel.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import Foundation
import FactoryKit

@Observable
final class ViewModel {
    @ObservationIgnored
    @Injected(\.adviceService) var adviceService
    
    private(set) var advice: Advice?
    private(set) var isError: Bool = false
    
    func fetchAdvice() async {
        isError = false
        
        do {
            advice = try await adviceService.fetchAdvice()
        } catch {
            isError = true
        }
    }
}
