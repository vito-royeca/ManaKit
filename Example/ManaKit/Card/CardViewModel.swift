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
    @Published var colors = [MGColor]()
    @Published var colorIdentities = [MGColor]()
    @Published var colorIndicators = [MGColor]()
    @Published var faces = [MGCard]()
    @Published var otherLanguages = [MGLanguage]()
    @Published var otherPrintings = [MGCard]()
    @Published var subtypes = [MGCardType]()
    @Published var supertypes = [MGCardType]()
    @Published var variations = [MGCard]()
    @Published var isBusy = false
    
    var newId: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(newId: String = "emn_en_15a", dataAPI: API = ManaKit.shared) {
        self.newId = newId
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
        
        dataAPI.fetchCard(id: newId,
                         cancellables: &cancellables,
                         completion: { result in
            switch result {
            case .success(let card):
                self.card = card
                self.colors = card.colors?.allObjects as? [MGColor] ?? []
                self.colorIdentities = card.colorIdentities?.allObjects as? [MGColor] ?? []
                self.colorIndicators = card.colorIndicators?.allObjects as? [MGColor] ?? []
                self.faces = card.faces?.allObjects as? [MGCard] ?? []
                self.otherLanguages = card.otherLanguages?.allObjects as? [MGLanguage] ?? []
                self.otherPrintings = card.otherPrintings?.allObjects as? [MGCard] ?? []
                self.subtypes = card.subtypes?.allObjects as? [MGCardType] ?? []
                self.supertypes = card.supertypes?.allObjects as? [MGCardType] ?? []
                self.variations = card.variations?.allObjects as? [MGCard] ?? []
            case .failure(let error):
                print(error)
            }
            
            self.isBusy.toggle()
        })
    }
}
