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
    
    var newID: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(newID: String = "emn_en_15a", dataAPI: API = ManaKit.shared) {
        self.newID = newID
        self.dataAPI = dataAPI
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
//        card = nil
    }
    
    func fetchData() {
        guard !isBusy && card == nil else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchCard(newID: newID,
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
