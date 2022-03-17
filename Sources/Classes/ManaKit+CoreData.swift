//
//  ManaKit+CoreData.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import CoreData
import Combine

extension NSManagedObjectID : Identifiable {
    
}

// MARK: - CodingUserInfoKey

public extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

// MARK: - Base class

public class MGEntity: NSManagedObject, Identifiable {
//    public required convenience init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//          throw DecoderConfigurationError.missingManagedObjectContext
//        }
//
//        self.init(context: context)
//    }
    convenience init(from entity: MEntity, context: NSManagedObjectContext) {
        self.init(context: context)
    }
}

extension ManaKit {
    
    // MARK: - CRUD
    
    func fetchData<T: MEntity>(_ entity: T.Type,
                                url: URL,
                                cancellables: inout Set<AnyCancellable>,
                                completion: @escaping (Result<Void, Error>) -> Void) {
        let success = {
            self.saveCache(forUrl: url)
            completion(.success(()))
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
            decoder.dateDecodingStrategy = .formatted(formatter)
            
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
                    
                }, receiveValue: { entities in
                    self.syncToCoreData(entities)
                })
                .store(in: &cancellables)
        } else {
            success()
        }
    }
    
    public func find<T: MGEntity>(_ entity: T.Type,
                                  properties: [String: Any]?,
                                  predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?,
                                  createIfNotFound: Bool,
                                  context: NSManagedObjectContext) -> [T]? {
        
        let entityName = String(describing: entity)
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let objects = try context.fetch(request)
            
            if !objects.isEmpty {
                objects.forEach {
                    for (key,value) in properties ?? [:] {
                        $0.setValue(value, forKey: key)
                    }
                }
                return objects
            } else {
                if createIfNotFound {
                    if let desc = NSEntityDescription.entity(forEntityName: entityName, in: context) {
                        try context.performAndWait {
                            let object = NSManagedObject(entity: desc, insertInto: context)
                            
                            for (key,value) in properties ?? [:] {
                                object.setValue(value, forKey: key)
                            }
                            
                            try context.save()
                        }
                        return find(entity,
                                    properties: properties,
                                    predicate: predicate,
                                    sortDescriptors: sortDescriptors,
                                    createIfNotFound: createIfNotFound,
                                    context: context)
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
    
    func delete<T: MGEntity>(_ entity: T.Type,
                             predicate: NSPredicate,
                             completion: (() -> Void)?) {
        let context = persistentContainer.viewContext
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate =  predicate
        
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

//    func count<T: MGEntity>(_ entity: T.Type, query: [String: Any]?) -> Int {
//        let context = persistentContainer.viewContext
//        let entityName = String(describing: entity)
//        let request = NSFetchRequest<T>(entityName: entityName)
//
//        request.predicate = predicate(fromQuery: query)
//        do {
//            return try context.count(for: request)
//        } catch {
//            print(error)
//            return 0
//        }
//    }
    
    public func saveContext () {
        let context = persistentContainer.viewContext

        guard context.hasChanges else {
            return
        }
        
        do {
            try context.performAndWait {
                try context.save()
            }
        } catch {
            print(error)
        }
    }

    func save(context: NSManagedObjectContext) {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Caching

    func willFetchCache(forUrl url: URL) -> Bool {
        let context = persistentContainer.viewContext //persistentContainer.newBackgroundContext()
        var willFetch = true

        if let cache = find(MGLocalCache.self,
                            properties: ["url": url.absoluteString],
                            predicate: NSPredicate(format: "url == %@", url.absoluteString),
                            sortDescriptors: nil,
                            createIfNotFound: true,
                            context: context)?.first {
            
            if let lastUpdated = cache.lastUpdated {
                // 5 minutes
                if let diff = Calendar.current.dateComponents([.minute],
                                                              from: lastUpdated,
                                                              to: Date()).minute {
                    willFetch = diff >= ManaKit.Constants.cacheAge
                }
            }
        }
        
        if willFetch {
            print(url)
        }
        return willFetch
    }

    func saveCache(forUrl url: URL) {
        let context = persistentContainer.viewContext //newBackgroundContext()
        
        if let cache = find(MGLocalCache.self,
                            properties: ["url": url.absoluteString],
                            predicate: NSPredicate(format: "url == %@", url.absoluteString),
                            sortDescriptors: nil,
                            createIfNotFound: true,
                            context: context)?.first {
            cache.lastUpdated = Date()
            save(context: context)
        }
    }

    func deleteCache(forUrl url: URL) {
        delete(MGLocalCache.self,
               predicate: NSPredicate(format: "url == %@", url.absoluteString),
               completion: nil)
        save(context: persistentContainer.viewContext)
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


