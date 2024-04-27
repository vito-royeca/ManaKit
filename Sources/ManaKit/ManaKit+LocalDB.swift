//
//  ManaKit+LocalDB.swift
//  
//
//  Created by Vito Royeca on 4/13/22.
//

import Foundation
import CoreData
import SQLite3

enum SQLiteError: Error {
    case open, exec, close
}
extension ManaKit {
    public func copyDatabase() {
        let fileName = "ManaKit"

        guard let sourceUrl = Bundle.main.url(forResource: fileName,
                                              withExtension: "sqlite"),
            let docsPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                               .userDomainMask, true).first else {
            return
        }

        let targetURL = URL(fileURLWithPath: "\(docsPath)/\(fileName).sqlite")

        if !FileManager.default.fileExists(atPath: "\(docsPath)/\(fileName).sqlite") {
            do {
                try FileManager.default.copyItem(at: sourceUrl, to: targetURL)
            } catch {
                print(error)
            }
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
    
    public func vacuumLocalDB() throws {
        var url: URL?
        
        for store in persistentContainer.persistentStoreCoordinator.persistentStores {
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
                throw SQLiteError.open
            }
            
            // set journal mode to DELETE
//            if sqlite3_exec(db, "PRAGMA journal_mode=DELETE;", nil, nil, nil) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("PRAGMA error: \(errmsg)")
//                throw SQLiteError.exec
//            }
            
            // vacuum
            if sqlite3_exec(db, "VACUUM;", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("VACUUM error: \(errmsg)")
                throw SQLiteError.exec
            }
            
            // close
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
                throw SQLiteError.close
            }
            
            db = nil

            print("done!")
        }
    }
}
