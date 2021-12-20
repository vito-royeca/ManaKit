//
//  SetsViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import ManaKit

protocol SetsViewModelProtocol {
    var sets: [MGSet] { get }
    
    func fetchData()
}

final class SetsViewModel: ObservableObject {
    @Published var sets = [MGSet]()
    
    var dataManager: SetsDataManagerProtocol
    
    init(dataManager: SetsDataManagerProtocol = SetsDataManager.shared) {
        self.dataManager = dataManager
    }
}

// MARK: - SetsViewModelProtocol
extension SetsViewModel: SetsViewModelProtocol {
    func fetchData() {
        dataManager.fetchData(completion: { result in
            switch result {
            case .success(let sets):
                self.sets = sets
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
