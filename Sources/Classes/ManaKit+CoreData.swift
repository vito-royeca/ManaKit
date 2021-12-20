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
    public func willFetchCache(_ entityName: String, objectFinder: [String: AnyObject]?) -> Bool {
        var newObjectFinder = ["name": entityName]
        var query: String?
        var willFetch = true
        
        if let objectFinder = objectFinder {
            query = ""
            for k in objectFinder.keys.sorted() {
                query!.append("\(k):\(objectFinder[k]!),")
            }
            newObjectFinder["query"] = query
        }

        if let dataCache = findObject(String(describing: MGLocalCache.self),
                                             objectFinder: newObjectFinder as [String : AnyObject],
                                             createIfNotFound: true) as? MGLocalCache {
            
            if let dateUpdated = dataCache.lastUpdated {
                if let diff = Calendar.current.dateComponents([.hour],
                                                              from: dateUpdated as Date,
                                                              to: Date()).hour {
                    willFetch = diff >= ManaKit.Constants.ManaGuideDataAge
                }
            }
            
            if willFetch {
                dataCache.tableName = entityName
                dataCache.query = query
//                if let objectFinder = objectFinder {
//                    dataCache.objectFinder = NSKeyedArchiver.archivedData(withRootObject: objectFinder)
//                }
                dataCache.lastUpdated = Date()
                saveContext()
            }
        }
        
        return willFetch
    }

    public func deleteCache(_ entityName: String, objectFinder: [String: AnyObject]?) {
        var newObjectFinder = ["tableName": entityName]
        var query: String?
        
        if let objectFinder = objectFinder {
            query = ""
            for k in objectFinder.keys.sorted() {
                query!.append("\(k):\(objectFinder[k]!),")
            }
            newObjectFinder["query"] = query
        }
        
        deleteObject(String(describing: MGLocalCache.self),
                     objectFinder: newObjectFinder as [String : AnyObject])
    }
    
    public func findObject(_ entityName: String,
                           objectFinder: [String: AnyObject]?,
                           createIfNotFound: Bool) -> NSManagedObject? {
//        let context = dataStack!.viewContext
        
        var object: NSManagedObject?
        var predicate: NSPredicate?
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if let objectFinder = objectFinder {
            for (key,value) in objectFinder {
                if predicate != nil {
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, NSPredicate(format: "%K == [c] %@", key, value as! NSObject)])
                } else {
                    predicate = NSPredicate(format: "%K == [c] %@", key, value as! NSObject)
                }
            }

            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest!.predicate = predicate
        }
        
//        if let fetchRequest = fetchRequest {
//            if let m = try! context.fetch(fetchRequest).first as? NSManagedObject {
//                object = m
//            } else {
//                if createIfNotFound {
//                    if let desc = NSEntityDescription.entity(forEntityName: entityName, in: context) {
//                        object = NSManagedObject(entity: desc, insertInto: context)
//                    }
//                }
//            }
//        }
        
        return object
    }
    
    public func findObjects(_ entityName: String,
                           objectFinder: [String: AnyObject]?) -> [NSManagedObject] {
//        let context = dataStack!.viewContext
        
        var objects = [NSManagedObject]()
        var predicate: NSPredicate?
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if let objectFinder = objectFinder {
            for (key,value) in objectFinder {
                if predicate != nil {
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, NSPredicate(format: "%K == [c] %@", key, value as! NSObject)])
                } else {
                    predicate = NSPredicate(format: "%K == [c] %@", key, value as! NSObject)
                }
            }

            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest!.predicate = predicate
        }
        
//        if let fetchRequest = fetchRequest {
//            objects = try! context.fetch(fetchRequest) as! [NSManagedObject]
//        }
        
        return objects
    }
    
    public func deleteObject(_ entityName: String, objectFinder: [String: AnyObject]?) {
//        guard let dataStack = dataStack,
//            let object = findObject(entityName, objectFinder: objectFinder, createIfNotFound: false) else {
//            return
//        }
//        dataStack.mainContext.delete(object)
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
    
    func copyDatabaseFile() {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
            let sourcePath = resourceBundle.path(forResource: "ManaKit.sqlite", ofType: "zip"),
            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return
        }
        let targetPath = "\(docsPath)/\(bundleName).sqlite"

//        if needsUpgrade() {
//            print("Copying database file: \(Constants.ScryfallDate)")
//            
//            // Shutdown database
//            dataStack = nil
//
//            // Remove old database files in docs directory
//            for file in try! FileManager.default.contentsOfDirectory(atPath: docsPath) {
//                let path = "\(docsPath)/\(file)"
//                if file.hasPrefix(bundleName) {
//                    try! FileManager.default.removeItem(atPath: path)
//                }
//            }
//            
//            // remove the contents of crop directory
//            let cropPath = "\(cachePath)/crop/"
//            if FileManager.default.fileExists(atPath: cropPath) {
//                for file in try! FileManager.default.contentsOfDirectory(atPath: cropPath) {
//                    let path = "\(cropPath)/\(file)"
//                    try! FileManager.default.removeItem(atPath: path)
//                }
//            }
//
//            // delete image cache
//            let imageCache = SDImageCache.init()
//            imageCache.clearDisk(onCompletion: nil)
//            
//            // Unzip
//            SSZipArchive.unzipFile(atPath: sourcePath, toDestination: docsPath)
//            
//            // rename
//            try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.sqlite", toPath: targetPath)
//            
//            // skip from iCloud backups!
//            var targetURL = URL(fileURLWithPath: targetPath)
//            var resourceValues = URLResourceValues()
//            resourceValues.isExcludedFromBackup = true
//            try! targetURL.setResourceValues(resourceValues)
//            
//            UserDefaults.standard.synchronize()
//        }
    }
    
    
    
}

// MARK: - Identifiables
//extension MGArtist : Identifiable {
//
//}
//
//extension MGCard : Identifiable {
//
//}
//
//extension MGCardComponentPart : Identifiable {
//
//}
//
//extension MGCardFormatLegality : Identifiable {
//
//}
//
//extension MGCardPrice : Identifiable {
//
//}
//
//extension MGCardType : Identifiable {
//
//}
//
//extension MGColor : Identifiable {
//
//}
//
//extension MGComponent : Identifiable {
//
//}
//
//extension MGFormat : Identifiable {
//
//}
//
//extension MGFrame : Identifiable {
//
//}
//
//extension MGFrameEffect : Identifiable {
//
//}
//
//extension MGLanguage : Identifiable {
//
//}
//
//extension MGLayout : Identifiable {
//
//}
//
//extension MGLegality : Identifiable {
//
//}
//
//extension MGLocalCache : Identifiable {
//
//}
//
//extension MGRarity : Identifiable {
//
//}
//
//extension MGRule : Identifiable {
//
//}
//
//extension MGRuling : Identifiable {
//
//}
//
//extension MGServerInfo : Identifiable {
//
//}
//
//extension MGSet : Identifiable {
//
//}
//
//extension MGSetBlock : Identifiable {
//
//}
//
//extension MGSetType : Identifiable {
//
//}
//
//extension MGStore : Identifiable {
//
//}
//
//extension MGWatermark : Identifiable {
//
//}
