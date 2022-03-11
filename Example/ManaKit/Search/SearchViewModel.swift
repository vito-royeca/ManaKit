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

class SearchViewModel: NSObject, ObservableObject {
    // MARK: - Published Variables
    @Published var cards = [MGCard]()
    @Published var isBusy = false
    
    // MARK: - Variables
    var dataAPI: API
    private var cancellables = Set<AnyCancellable>()
    private var frc: NSFetchedResultsController<MGCard>
    
    // MARK: - Initializers
    init(dataAPI: API = ManaKit.shared) {
        self.dataAPI = dataAPI
        frc = NSFetchedResultsController(fetchRequest: MGCard.fetchRequest(),
                                         managedObjectContext: ManaKit.shared.persistentContainer.viewContext,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
        cards.removeAll()
    }
    
    // MARK: - Methods
    func fetchData(query: String) {
        guard !isBusy else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchCards(query: query,
                           cancellables: &cancellables,
                           completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchLocalData(query: query)
                case .failure(let error):
                    print(error)
                    self.cards.removeAll()
                }
                
                self.isBusy.toggle()
            }
        })
    }
    
    func fetchLocalData(query: String) {
        frc = NSFetchedResultsController(fetchRequest: defaultFetchRequest(query: query),
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

    func clearData() {
        cards.removeAll()
        isBusy = false
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension SearchViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let cards = controller.fetchedObjects as? [MGCard] else {
            return
        }

        self.cards = cards
    }
}

// MARK: - NSFetchRequest
extension SearchViewModel {
    func defaultFetchRequest(query: String) -> NSFetchRequest<MGCard> {
        let sortDescriptors = [NSSortDescriptor(key: "set.releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        let predicate = NSPredicate(format: "newID != nil AND newID != '' AND name CONTAINS[cd] %@ AND collectorNumber != nil ", query)
        
        let request: NSFetchRequest<MGCard> = MGCard.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate

        return request
    }
}
