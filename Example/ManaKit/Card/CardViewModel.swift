//
//  CardViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Combine
import CoreData
import SwiftUI
import ManaKit

class CardViewModel: ObservableObject {
    @Published var card: MGCard?
    @Published var isBusy = false
    
    var newId: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(newId: String = "emn_en_15a", dataAPI: API = ManaKit.shared) {
        self.newId = newId
        self.dataAPI = dataAPI
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
        card = nil
    }
    
    func fetchData() {
        guard !isBusy && card == nil else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchCard(newId: newId,
                         cancellables: &cancellables,
                         completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self.card = card
                case .failure(let error):
                    print(error)
                    self.card = nil
                }
                
                self.isBusy.toggle()
            }
        })
    }
}
