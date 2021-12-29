//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Combine
import CoreData
import SwiftUI
import ManaKit

class SetViewModel: ObservableObject {
    @Published var set: MGSet?
    @Published var cards = [MGCard]()
    @Published var isBusy = false
    
    var setCode: String
    var languageCode: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(setCode: String = "emn", languageCode: String = "en", dataAPI: API = ManaKit.shared) {
        self.setCode = setCode
        self.languageCode = languageCode
        self.dataAPI = dataAPI
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
    }
    
    func fetchData() {
        guard !isBusy else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchSet(code: setCode,
                         languageCode: languageCode,
                         cancellables: &cancellables,
                         completion: { result in
            switch result {
            case .success(let set):
                self.set = set
                self.cards = (set.cards?.allObjects as? [MGCard] ?? [MGCard]())
                    .filter{ $0.newId != nil }
                    .sorted{ $0.name ?? "" < $1.name ?? ""}
            case .failure(let error):
                print(error)
            }
            
            self.isBusy.toggle()
        })
    }
}
