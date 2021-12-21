//
//  ManaKit+CoreData.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import CoreData
import PromiseKit
import SDWebImage
//import SSZipArchive
//import Sync

extension ManaKit {
    public func willFetchCache<T: NSManagedObject>(_ entity: T.Type, query: [String: Any]?) -> Bool {
        let entityName = String(describing: entity)
        var willFetch = true
        var newQuery = [String: Any]()
        
        if let query = query {
            for (k,v) in query {
                newQuery[k] = v
            }
        }
        newQuery["tableName"] = entityName
        
        if let cache = find(MGLocalCache.self,
                            query: newQuery,
                            sortDescriptors: nil,
                            createIfNotFound: true)?.first {
            
            if let lastUpdated = cache.lastUpdated {
                // 5 minutes
                if let diff = Calendar.current.dateComponents([.minute],
                                                              from: lastUpdated,
                                                              to: Date()).minute {
                    willFetch = diff >= ManaKit.Constants.ManaGuideDataAge
                }
            }
            
            if willFetch {
                do {
                    let context = persistentContainer.viewContext
                    cache.lastUpdated = Date()
                    cache.tableName = entityName
                    
                    try context.save()
                } catch {
                    print(error)
                    return false
                }
            }
        }
        
        return willFetch
    }

    public func find<T: NSManagedObject>(_ entity: T.Type,
                                         query: [String: Any]?,
                                         sortDescriptors: [NSSortDescriptor]?,
                                         createIfNotFound: Bool) -> [T]? {
        let context = persistentContainer.viewContext
        let entityName = String(describing: entity)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        request.predicate = predicate(fromQuery: query)
        request.sortDescriptors = sortDescriptors
        do {
            let objects = try context.fetch(request)
            
            if !objects.isEmpty {
                return objects
            } else {
                if createIfNotFound {
                    if let desc = NSEntityDescription.entity(forEntityName: entityName, in: context) {
                        let object = NSManagedObject(entity: desc, insertInto: context)
                        
                        if let query = query {
                            for (key,value) in query {
                                object.setValue(value, forKey: key)
                            }
                        }
                        try context.save()
                        
                        return find(entity, query: query, sortDescriptors: sortDescriptors, createIfNotFound: createIfNotFound)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    public func delete<T: NSManagedObject>(_ entity: T.Type, query: [String: AnyObject]?, completion: () -> Void) {
        let context = persistentContainer.viewContext
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate =  predicate(fromQuery: query)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            if let result = try context.execute(deleteRequest) as? NSBatchDeleteResult,
               let objectIDArray = result.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey : objectIDArray]

                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
            completion()
        } catch {
            print("Failed to perform batch update: \(error)")
            completion()
        }
    }

    func count<T: NSManagedObject>(_ entity: T.Type, query: [String: AnyObject]?) -> Int {
        let context = persistentContainer.viewContext
        let entityName = String(describing: entity)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        request.predicate = predicate(fromQuery: query)
        do {
            return try context.count(for: request)
        } catch {
            print(error)
            return 0
        }
    }
    
    func predicate(fromQuery query: [String: Any]?) -> NSPredicate? {
        var predicate: NSPredicate?
        
        if let query = query {
            for (key, value) in query {
                var format = "[c] %@"
                if let _ = value as? Int32 {
                    format = "%d"
                } else if let _ = value as? Double {
                    format = "%f"
                } else if let _ = value as? Bool {
                    format = "%d"
                }
                
                if predicate != nil {
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, NSPredicate(format: "%K == \(format)", key, value as! CVarArg)])
                } else {
                    predicate = NSPredicate(format: "%K == \(format)", key, value as! CVarArg)
                }
            }
        }
        
        return predicate
    }

    
//    public func saveContext() {
//        guard let dataStack = dataStack else {
//            return
//        }
//
//        if dataStack.mainContext.hasChanges {
//            do {
//                try dataStack.mainContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
//    func copyModelFile() {
//        guard let modelURL = Bundle(for: type(of: self)).url(forResource: "ManaKit", withExtension: "momd"),
//              let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
//              let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
////              let sourcePath = resourceBundle.path(forResource: "ManaKit.sqlite", ofType: "zip"),
//              let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
//            return
//        }
//        let targetPath = "\(docsPath)/\(bundleName).momd"
//        
//        print(modelURL)
//        print(targetPath)
//        if !FileManager.default.fileExists(atPath: targetPath) {
//            try! FileManager.default.copyItem(atPath: modelURL.path, toPath: targetPath)
//        }
//    }
    
//    func copyDatabaseFile() {
//        let bundle = Bundle(for: ManaKit.self)
//        
//        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
//            let resourceBundle = Bundle(url: bundleURL),
//            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
//            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
////            let sourcePath = resourceBundle.path(forResource: "ManaKit.sqlite", ofType: "zip"),
//            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
//            return
//        }
//        let targetPath = "\(docsPath)/\(bundleName).sqlite"
//
////        if needsUpgrade() {
//            print("Copying database file...")
////            
////            // Shutdown database
////            dataStack = nil
////
////            // Remove old database files in docs directory
//            for file in try! FileManager.default.contentsOfDirectory(atPath: docsPath) {
//                let path = "\(docsPath)/\(file)"
//                if file.hasPrefix(bundleName) {
//                    try! FileManager.default.removeItem(atPath: path)
//                }
//            }
////            
////            // remove the contents of crop directory
//            let cropPath = "\(cachePath)/crop/"
//            if FileManager.default.fileExists(atPath: cropPath) {
//                for file in try! FileManager.default.contentsOfDirectory(atPath: cropPath) {
//                    let path = "\(cropPath)/\(file)"
//                    try! FileManager.default.removeItem(atPath: path)
//                }
//            }
////
////            // delete image cache
//            let imageCache = SDImageCache.init()
//            imageCache.clearDisk(onCompletion: nil)
////            
////            // Unzip
////            SSZipArchive.unzipFile(atPath: sourcePath, toDestination: docsPath)
////            
////            // rename
////            try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.sqlite", toPath: targetPath)
////            
////            // skip from iCloud backups!
////            var targetURL = URL(fileURLWithPath: targetPath)
////            var resourceValues = URLResourceValues()
////            resourceValues.isExcludedFromBackup = true
////            try! targetURL.setResourceValues(resourceValues)
////            
////            UserDefaults.standard.synchronize()
////        }
//    }
    
    
    
}

