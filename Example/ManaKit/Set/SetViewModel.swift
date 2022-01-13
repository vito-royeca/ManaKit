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
    @Published var set: MSet?
    @Published var cards = [MCard]()
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
        set = nil
        cards.removeAll()
    }
    
    func fetchData() {
        guard !isBusy && set == nil else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchSet(code: setCode,
                         languageCode: languageCode,
                         cancellables: &cancellables,
                         completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let set):
                DispatchQueue.main.async {
                    self.set = set
                    self.findCards()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func findCards() {
        guard let set = set else {
            return
        }
        
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        cards = ManaKit.shared.find(MCard.self,
                                    properties: nil,
                                    predicate: NSPredicate(format: "set.code == %@ AND language.code == %@", set.code ?? "", "en"),
                                    sortDescriptors: sortDescriptors,
                                    createIfNotFound: false) ?? []
    }
}
