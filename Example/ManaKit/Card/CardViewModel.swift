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
    @Published var card: MCard?
//    @Published var colors = [MColor]()
//    @Published var colorIdentities = [MColor]()
//    @Published var colorIndicators = [MColor]()
//    @Published var faces = [MCard]()
//    @Published var otherLanguages =  [MLanguage]()
//    @Published var otherPrintings = [MCard]()
//    @Published var subtypes = [MCardType]()
//    @Published var supertypes = [MCardType]()
//    @Published var variations = [MCard]()
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
        
        card = nil
//        colors.removeAll()
//        colorIdentities.removeAll()
//        colorIndicators.removeAll()
//        faces.removeAll()
//        otherLanguages.removeAll()
//        otherPrintings.removeAll()
//        subtypes.removeAll()
//        supertypes.removeAll()
//        variations.removeAll()
    }
    
    func fetchData() {
        guard !isBusy && card == nil else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchCard(newId: newId,
                         cancellables: &cancellables,
                         completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let card):
                DispatchQueue.main.async {
                    self.card = card
//                    self.findColors()
//                    self.findColorIdentities()
//                    self.findColorIndicators()
//                    self.findFaces()
//                    self.findOtherLanguages()
//                    self.findOtherPrintings()
//                    self.findSubtypes()
//                    self.findSupertypes()
//                    self.findVariations()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
//    func findColors() {
//        guard let card = card else {
//            return
//        }
//
//        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        colors = ManaKit.shared.find(MColor.self,
//                                    query: ["set.code": set.code ?? "",
//                                            "language.code": "en"],
//                                    sortDescriptors: sortDescriptors,
//                                    createIfNotFound: false) ?? []
//
//        guard let objects = card?.colors?.allObjects as? [MGColor],
//           !objects.isEmpty else {
//            colors.removeAll()
//            return
//        }
//
//        colors = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchColorIdentities() {
//        guard let objects = card?.colorIdentities?.allObjects as? [MGColor],
//           !objects.isEmpty else {
//            colorIdentities.removeAll()
//            return
//        }
//
//        colorIdentities = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchColorIndicators() {
//        guard let objects = card?.colorIndicators?.allObjects as? [MGColor],
//           !objects.isEmpty else {
//            colorIndicators.removeAll()
//            return
//        }
//
//        colorIndicators = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchFaces() {
//        let sortDescriptors = [NSSortDescriptor(key: "faceOrder", ascending: true)]
//
//        guard let objects = ManaKit.shared.find(MGCard.self,
//                                                query: ["face.newId": newId],
//                                                sortDescriptors: sortDescriptors,
//                                                createIfNotFound: false),
//           !objects.isEmpty else {
//            faces.removeAll()
//            return
//        }
//
//        faces = objects
//    }
//
//    fileprivate func fetchOtherLanguages() {
//        guard let objects = card?.otherLanguages?.allObjects as? [MGLanguage],
//           !objects.isEmpty else {
//            otherLanguages.removeAll()
//            return
//        }
//
//        otherLanguages = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchOtherPrintings() {
//        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: false)]
//
//        guard let objects = ManaKit.shared.find(MGCard.self,
//                                                query: ["otherPrinting.newId": newId],
//                                                sortDescriptors: sortDescriptors,
//                                                createIfNotFound: false),
//           !objects.isEmpty else {
//            otherPrintings.removeAll()
//            return
//        }
//
//        otherPrintings = objects
//    }
//
//    fileprivate func fetchSubtypes() {
//        guard let objects = card?.subtypes?.allObjects as? [MGCardType],
//           !objects.isEmpty else {
//            subtypes.removeAll()
//            return
//        }
//
//        subtypes = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchSupertypes() {
//        guard let objects = card?.supertypes?.allObjects as? [MGCardType],
//           !objects.isEmpty else {
//            supertypes.removeAll()
//            return
//        }
//
//        subtypes = objects.sorted { $0.name ?? "" < $1.name ?? ""}
//    }
//
//    fileprivate func fetchVariations() {
//        let sortDescriptors = [NSSortDescriptor(key: "collectorNumber", ascending: true)]
//
//        guard let objects = ManaKit.shared.find(MGCard.self,
//                                                query: ["variation.newId": newId],
//                                                sortDescriptors: sortDescriptors,
//                                                createIfNotFound: false),
//           !objects.isEmpty else {
//            variations.removeAll()
//            return
//        }
//
//        variations = objects
//    }
}
