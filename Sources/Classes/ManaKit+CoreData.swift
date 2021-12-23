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
    // MARK: - CRUD
    func fetchOneData<T: MGEntity>(_ entity: T.Type,
                                   query: [String: Any]?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   url: URL,
                                   cancellables: inout Set<AnyCancellable>,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        fetchData(entity,
                  query: query,
                  sortDescriptors: sortDescriptors,
                  url: url,
                  cancellables: &cancellables,
                  completion: { result in
            switch result {
            case .success(let data):
                completion(.success(data[0]))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        })
    }
    
    func fetchData<T: MGEntity>(_ entity: T.Type,
                                query: [String: Any]?,
                                sortDescriptors: [NSSortDescriptor]?,
                                url: URL,
                                cancellables: inout Set<AnyCancellable>,
                                completion: @escaping (Result<[T], Error>) -> Void) {
        let success = {
            let result = self.find(entity,
                                   query: query,
                                   sortDescriptors: sortDescriptors,
                                   createIfNotFound: false) ?? [T]()
            self.saveCache(forUrl: url)
            completion(.success(result))
        }
        
        let failure = { (error: Error) in
            print(error)
            self.deleteCache(forUrl: url)
            completion(.failure(error))
        }
        
        if willFetchCache(forUrl: url) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(formatter)
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
                        success()
                    case .failure(let error):
                        failure(error)
                    }
                }, receiveValue: { _ /*[weak self] (sets)*/ in
                    self.saveContext()
                })
                .store(in: &cancellables)
        } else {
            success()
        }
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
//                        context.performAndWait {
                            let object = NSManagedObject(entity: desc, insertInto: context)
                            
                            if let query = query {
                                for (key,value) in query {
                                    object.setValue(value, forKey: key)
                                }
                            }
                            self.saveContext()
//                        }
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
                                    query: [String: Any]?,
                                    completion: (() -> Void)?) {
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
            completion?()
        } catch {
            print("Failed to perform batch update: \(error)")
            completion?()
        }
    }

    public func count<T: NSManagedObject>(_ entity: T.Type, query: [String: Any]?) -> Int {
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
    
    public func saveContext () {
        let context = persistentContainer.viewContext//newBackgroundContext()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Utilities
    func predicate(fromQuery query: [String: Any]?) -> NSPredicate? {
        var predicate: NSPredicate?
        
        if let query = query {
            for (key, value) in query {
                var format = "%@"
                
                if let _ = value as? Int32 {
                    format = "%d"
                } else if let _ = value as? Double {
                    format = "%f"
                } else if let _ = value as? Bool {
                    format = "%d"
                } else if let _ = value as? String {
                    format = "[c] %@"
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
    
    // MARK: - Caching

    func willFetchCache(forUrl url: URL) -> Bool {
        var willFetch = true

        if let cache = find(MGLocalCache.self,
                            query: ["url": url.absoluteString],
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
                print(url)
            }
        }
        
        return willFetch
    }

    func saveCache(forUrl url: URL) {
        if let cache = find(MGLocalCache.self,
                            query: ["url": url.absoluteString],
                            sortDescriptors: nil,
                            createIfNotFound: true)?.first {
            cache.lastUpdated = Date()
            saveContext()
        }
    }
    
    func deleteCache(forUrl url: URL) {
        delete(MGLocalCache.self,
                    query: ["url": url.absoluteString],
                    completion: nil)
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

