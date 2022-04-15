//
//  ManaKit+LocalDB.swift
//  
//
//  Created by Vito Royeca on 4/13/22.
//

import Foundation
import CoreData
import SQLite3

extension ManaKit {
    public func createLocalDB() {
        let group = DispatchGroup()
        
        // 1) start fetch sets
        group.enter()
        ManaKit.shared.fetchSets(completion: { result in
            switch result {
            case .success:
                let sets = self.fetchLocalSets()
                let setsCount = sets.count
                var index = 0
                
                for set in sets {
                    for language in set.sortedLanguages ?? [] {
                        
                        // 2) start fetch set/language
                        group.enter()
                        ManaKit.shared.fetchSet(code: set.code, languageCode: language.code ?? "", completion: { result in
                            switch result {
                            case .success(let set):
                                if let set = set {
                                    for card in self.fetchLocalCards(setCode: set.code, languageCode: language.code ?? "") {
                                        
                                        // 3) start fetch card
                                        group.enter()
                                        ManaKit.shared.fetchCard(newID: card.newIDCopy, completion: { result in
                                            switch result {
                                            case .success(let card):
                                                if let card = card {
                                                    print("fetched \(card.newIDCopy)")
                                                } else {
                                                    print("fail!!!")
                                                }
                                            case .failure(let error):
                                                print(error)
                                            }
                                            
                                            // 3) end fetch card
                                            sleep(1)
                                            group.leave()
                                        })
                                    }
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                            
                            print("Sleeping... \(index)/\(setsCount)")
                            index += 1
                            sleep(1)
                            // 2) end fetch set/language
                            group.leave()
                        })
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            // 1) end fetch sets
            group.leave()
        })

        group.notify(queue: DispatchQueue.global()) {
            print("Done")
        }
    }
    
    func fetchLocalSets() -> [MGSet] {
        let request: NSFetchRequest<MGSet> = MGSet.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false),
                               NSSortDescriptor(key: "name", ascending: true)]
        
        request.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: ManaKit.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        var sets = [MGSet]()
        
        do {
            try frc.performFetch()
            sets = frc.fetchedObjects ?? []
        } catch {
            print(error)
        }
        
        return sets
    }
    
    func fetchLocalCards(setCode: String, languageCode: String) -> [MGCard] {
        let request: NSFetchRequest<MGCard> = MGCard.fetchRequest()
        let predicate = NSPredicate(format: "set.code == %@ AND language.code == %@ AND collectorNumber != null ", setCode, languageCode)
        let sortDescriptors = [NSSortDescriptor(key: "collectorNumber", ascending: true)]
        
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: ManaKit.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        var cards = [MGCard]()
        
        do {
            try frc.performFetch()
            cards = frc.fetchedObjects ?? []
        } catch {
            print(error)
        }
        
        return cards
    }
    
    func vacuumLocalDB() {
        var url: URL?
        
        for store in persistentStoreCoordinator.persistentStores {
            url = store.url
        }
        
        if let url = url {
            print("vacuuming the database...")

            // open database
            var db: OpaquePointer?
            guard sqlite3_open(url.path, &db) == SQLITE_OK else {
                print("error opening database")
                sqlite3_close(db)
                db = nil
                return
            }
            
            if sqlite3_exec(db, "VACUUM;", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("VACUUM error: \(errmsg)")
            }
            
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            db = nil
            
            print("done!")
        }
    }
}
