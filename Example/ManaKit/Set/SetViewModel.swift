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

class SetViewModel: NSObject, ObservableObject {
    
    // MARK: - Published Variables
    @Published var set: MGSet?
    @Published var cards = [MGCard]()
    @Published var isBusy = false
    
    // MARK: - Variables
    var setCode: String
    var languageCode: String
    var dataAPI: API
    private var cancellables = Set<AnyCancellable>()
    private var frc: NSFetchedResultsController<MGCard>
    
    // MARK: - Initializers
    init(setCode: String = "emn", languageCode: String = "en", dataAPI: API = ManaKit.shared) {
        self.setCode = setCode
        self.languageCode = languageCode
        self.dataAPI = dataAPI
        
        frc = NSFetchedResultsController(fetchRequest: MGCard.fetchRequest(),
                                         managedObjectContext: ManaKit.shared.persistentContainer.viewContext,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
        
        super.init()
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
        
        set = nil
        cards.removeAll()
    }
    
    // MARK: - Methods
    func fetchData() {
        guard !isBusy && set == nil && cards.isEmpty else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchSet(code: setCode,
                         languageCode: languageCode,
                         cancellables: &cancellables,
                         completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let set):
                    self.set = set
                    self.fetchLocalData()
                case .failure(let error):
                    print(error)
                    self.set = nil
                    self.cards.removeAll()
                }
                
                self.isBusy.toggle()
            }
        })
    }
    
    func fetchLocalData() {
        frc = NSFetchedResultsController(fetchRequest: defaultFetchRequest(setCode: setCode, languageCode: languageCode),
                                         managedObjectContext: ManaKit.shared.persistentContainer.viewContext,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
            cards = frc.fetchedObjects ?? []
        } catch {
            print(error)
            self.cards.removeAll()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension SetViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let cards = controller.fetchedObjects as? [MGCard] else {
            return
        }

        self.cards = cards
    }
}

// MARK: - NSFetchRequest
extension SetViewModel {
    func defaultFetchRequest(setCode: String, languageCode: String) -> NSFetchRequest<MGCard> {
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let predicate = NSPredicate(format: "set.code == %@ AND language.code == %@", setCode, languageCode)
        
        let request: NSFetchRequest<MGCard> = MGCard.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        return request
    }
}
