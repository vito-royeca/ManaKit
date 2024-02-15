//
//  ManaKit+CoreData.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import CoreData

extension NSManagedObjectID : Identifiable {
    
}

// MARK: - CodingUserInfoKey

public extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

// MARK: - Base class

public class MGEntity: NSManagedObject, Identifiable {
    convenience init(from entity: MEntity, context: NSManagedObjectContext) {
        self.init(context: context)
    }
}

extension ManaKit {
    
    // MARK: - CRUD
    
    public func find<T: MGEntity>(_ entity: T.Type,
                                  properties: [String: Any]?,
                                  predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?,
                                  createIfNotFound: Bool,
                                  context: NSManagedObjectContext? = nil) -> [T]? {
        
        let context = context ?? viewContext
        let entityName = String(describing: entity)
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let objects = try context.fetch(request)
            
            if !objects.isEmpty {
                objects.forEach {
                    for (key,value) in properties ?? [:] {
                        if let oldValue = $0.value(forKey: key) {
                            if "\(oldValue)" != "\(value)" {
                                $0.setValue(value, forKey: key)
                            }
                        } else {
                            $0.setValue(value, forKey: key)
                        }
                    }
                }
                try context.save()
                return objects

            } else {
                if createIfNotFound,
                   let predicate = predicate,
                   let desc = NSEntityDescription.entity(forEntityName: entityName,
                                                         in: context) {
                    let object = NSManagedObject(entity: desc, insertInto: context)
                    
                    for (key,value) in properties ?? [:] {
                        object.setValue(value, forKey: key)
                    }
                    
                    try context.save()
                    
                    return find(entity,
                                properties: properties,
                                predicate: predicate,
                                sortDescriptors: sortDescriptors,
                                createIfNotFound: createIfNotFound,
                                context: context)
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
                             predicate: NSPredicate) async throws {
        let context = viewContext
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
        } catch {
            print("Failed to perform batch update: \(error)")
            throw error
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
    
    public func saveContext() {
        let context = viewContext

        guard context.hasChanges else {
            return
        }
        
        do {
//            try context.performAndWait {
                try context.save()
//            }
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
    
    // MARK: - Other methods

    func object<T: MGEntity>(_ entity: T.Type,
                             with id: NSManagedObjectID) -> T {
        return viewContext.object(with: id) as! T
    }    
}


