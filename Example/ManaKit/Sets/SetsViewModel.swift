//
//  SetsViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import Combine
import ManaKit

class SetsViewModel: ObservableObject {
    @Published var sets = [MSet]()
    @Published var isBusy = false
    
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(dataAPI: API = ManaKit.shared) {
        self.dataAPI = dataAPI
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
        sets.removeAll()
    }
    
    func fetchData() {
        guard !isBusy && sets.isEmpty else {
            return
        }
        
        isBusy.toggle()
        
        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]

        dataAPI.fetchSets(predicate: nil,
                          sortDescriptors: sortDescriptors,
                          cancellables: &cancellables,
                          completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let sets):
                DispatchQueue.main.async {
                    self.sets = sets
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
