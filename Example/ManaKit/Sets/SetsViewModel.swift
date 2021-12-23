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

class SetsViewModel: ObservableObject {
    @Published var sets = [MGSet]()
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
    }
        
    func fetchData() {
        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]

        isBusy.toggle()
        dataAPI.fetchSets(query: nil,
                          sortDescriptors: sortDescriptors,
                          cancellables: &cancellables,
                          completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let sets):
                self.sets = sets
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
