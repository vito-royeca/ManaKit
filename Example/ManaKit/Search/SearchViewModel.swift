//
//  SearchViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 1/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import Combine
import SwiftUI
import ManaKit

class SearchViewModel: ObservableObject {
    @Published var cards = [MCard]()
    @State var isBusy = false
    
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(dataAPI: API = ManaKit.shared) {
        self.dataAPI = dataAPI
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
        cards.removeAll()
    }
    
    func fetchData(query: String) {
        guard !isBusy else {
            return
        }
        
        isBusy.toggle()
        
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]

        dataAPI.fetchCards(query: query,
                           predicate: NSPredicate(format: "newId != nil AND newId != '' AND name CONTAINS[cd] %@", query),
                           sortDescriptors: sortDescriptors,
                           cancellables: &cancellables,
                           completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let cards):
                DispatchQueue.main.async {
                    self.cards = cards
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func clearData() {
        cards.removeAll()
        isBusy = false
    }
}
