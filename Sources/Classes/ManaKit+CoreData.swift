//
//  ManaKit+CoreData.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import CoreData
import Combine

extension ManaKit {
    func fetchData<T: MGEntity>(_ entity: T.Type,
                                query: [String: Any]?,
                                sortDescriptors: [NSSortDescriptor]?,
                                url: URL,
                                cancellables: inout Set<AnyCancellable>,
                                completion: @escaping (Result<[T], Error>) -> Void) {
        let done = {
            let result = self.find(entity,
                                   query: nil,
                                   sortDescriptors: sortDescriptors,
                                   createIfNotFound: false) ?? [T]()
            completion(.success(result))
        }
        
        if willFetchCache(entity, query: query) {
            guard let url = URL(string: "\(apiURL)/sets?json=true") else {
                completion(.failure(ManaKitError.badURL))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
            
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: sessionProcessingQueue)
                .map({
                    return $0.data
                })
                .decode(type: [T].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (suscriberCompletion) in
                    switch suscriberCompletion {
                    case .finished:
                        done()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { _ /*[weak self] (sets)*/ in
                    self.saveContext()
                })
                .store(in: &cancellables)
        } else {
            done()
        }
    }
    
    func willFetchCache<T: MGEntity>(_ entity: T.Type, query: [String: Any]?) -> Bool {
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
                cache.lastUpdated = Date()
                cache.tableName = entityName
                saveContext()
            }
        }
        
        return willFetch
    }

    func find<T: MGEntity>(_ entity: T.Type,
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
                        saveContext()
                        
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
    
    public func delete<T: MGEntity>(_ entity: T.Type,
                                    query: [String: AnyObject]?,
                                    completion: () -> Void) {
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

    public func count<T: NSManagedObject>(_ entity: T.Type, query: [String: AnyObject]?) -> Int {
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

    public func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
        
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

