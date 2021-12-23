//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//
//@available(iOS 10, *)
//import UIKit
//@available(OSX 10, *)
//import NSKit

import KeychainAccess
//import PromiseKit
import SDWebImage
import Combine
import CoreData

public class ManaKit {
    // MARK: - Constants
    
    public enum Fonts {
        public static let preEightEdition      = UIFont(name: "Magic:the Gathering", size: 17.0)
        public static let preEightEditionSmall = UIFont(name: "Magic:the Gathering", size: 15.0)
        public static let eightEdition         = UIFont(name: "Matrix-Bold", size: 17.0)
        public static let eightEditionSmall    = UIFont(name: "Matrix-Bold", size: 15.0)
        public static let magic2015            = UIFont(name: "Beleren", size: 17.0)
        public static let magic2015Small       = UIFont(name: "Beleren", size: 15.0)
    }

    public enum Constants {
        public static let EightEditionRelease = "2003-07-28"
        public static let ManaGuideDataAge    = 5 // 5 mins
    }
    
    public enum ImageName: String {
        case cardCircles       = "images/Card_Circles",
        cardBackCropped        = "images/cardback-crop-hq",
        cardBack               = "images/cardback-hq",
        collectorsCardBack     = "images/collectorscardback-hq",
        cropBack               = "images/cropback-hq",
        grayPatterned          = "images/Gray_Patterned_BG",
        intlCollectorsCardBack = "images/internationalcollectorscardback-hq"
    }
    
    public enum UserDefaultsKeys {
        public static let ScryfallDate          = "ScryfallDate"
        public static let KeyruneVersion        = "KeyruneVersion"
        public static let MTGJSONVersion        = "kMTGJSONVersion"
    }
    
//    public static let queryCachePrefix = "cache_"
    
    // MARK: - Variables

    var apiURL = ""
    
    var _keyChain: Keychain?
    var keychain: Keychain {
        get {
            if _keyChain == nil {
                _keyChain = Keychain(service: "com.managuide.ManaKit")
            }
            return _keyChain!
        }
    }
    
    let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    // MARK: - Shared Instance
    
    public static let shared = ManaKit()
    
    // MARK: - Initializers
    
    private init() { }

    
    // MARK: - Resource methods
    
    public func configure(apiURL: String) {
        self.apiURL = apiURL
    }
    
    public func nibFromBundle(_ name: String) -> UINib? {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL) else {
            return nil
        }
        
        return UINib(nibName: name, bundle: resourceBundle)
    }
    
    public func setupResources() {
//        copyModelFile()
//        copyDatabaseFile()
        loadCustomFonts()
    }
    
    func loadCustomFonts() {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL),
            let urls = resourceBundle.urls(forResourcesWithExtension: "ttf", subdirectory: "fonts") else {
            return
        }
        
        for url in urls {
            let data = try! Data(contentsOf: url)
            let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil

            if let provider = CGDataProvider(data: data as CFData),
                let font = CGFont(provider) {
                
                if !CTFontManagerRegisterGraphicsFont(font, error) {
                    if let unmanagedError = error?.pointee {
                        if let errorDescription = CFErrorCopyDescription(unmanagedError.takeUnretainedValue()) {
                            print("Failed to load font: \(errorDescription)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Firebase
//    public func newFirebaseKey(from oldFirebaseKey: String) -> String {
//        var parts = oldFirebaseKey.components(separatedBy: "_")
//        var numComponent = ""
//        let capName = parts[1]
//
//        if parts.filter({ (isIncluded) -> Bool in
//            return isIncluded.lowercased().hasPrefix(capName.lowercased())
//        }).count > 1 {
//            numComponent = parts.remove(at: 2)
//            numComponent = numComponent.replacingOccurrences(of: capName.lowercased(), with: "")
//        }
//
//        var newKey = parts.joined(separator: "_")
//        if !numComponent.isEmpty {
//            newKey = "\(newKey)_\(numComponent)"
//        }
//        return encodeFirebase(key: newKey)
//    }
//
//    public func encodeFirebase(key: String) -> String {
//        return key.replacingOccurrences(of: ".", with: "P%n*")
//            .replacingOccurrences(of: "$", with: "D%n*")
//            .replacingOccurrences(of: "#", with: "H%n*")
//            .replacingOccurrences(of: "[", with: "On%*")
//            .replacingOccurrences(of: "]", with: "n*C%")
//            .replacingOccurrences(of: "/", with: "*S%n")
//    }
//
//    public func decodeFirebase(key: String) -> String {
//        return key.replacingOccurrences(of: "P%n*", with: ".")
//            .replacingOccurrences(of: "D%n*", with: "$")
//            .replacingOccurrences(of: "H%n*", with: "#")
//            .replacingOccurrences(of: "On%*", with: "[")
//            .replacingOccurrences(of: "n*C%", with: "]")
//            .replacingOccurrences(of: "*S%n", with: "/")
//    }
    
    // MARK: - DatabaseProtocol
    
//    public typealias ObjectType = NSManagedObject
//    public typealias PredicateType = NSPredicate
//    var context: NSManagedObjectContext { persistentContainer.viewContext }
//
//    public func create(_ object: NSManagedObject) {
//        do {
//            try context.save()
//        } catch {
//            fatalError("error saving context while creating an object")
//        }
//    }
//
//    public func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
//        let request = objectType.fetchRequest()
//        request.predicate = predicate
//
//        if let limit = limit {
//            request.fetchLimit = limit
//        }
//        do {
//            let result = try context.fetch(request)
//            return .success(result as? [T] ?? [])
//        } catch {
//            return .failure(error)
//        }
//    }
//
//    public func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
//        let result = fetch(objectType, predicate: predicate, limit: 1)
//
//        switch result {
//        case .success(let objects):
//            return .success(objects.first as? T)
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
//
//    public func update(_ object: NSManagedObject) {
//        do {
//            try context.save()
//        } catch {
//            fatalError("error saving context while updating an object")
//        }
//    }
//
//    public func delete(_ object: NSManagedObject) {
//
//    }
    
    // MARK: - Core Data
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: ManaKit.self)
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "ManaKit"
        
        guard let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
           let managedObjectModel = NSManagedObjectModel(contentsOf: momURL) else {
               fatalError("Can't load persistent container")
           }
        let container = NSPersistentContainer(name: bundleName, managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
}

//public protocol DatabaseProtocol {
//    associatedtype ObjectType
//    associatedtype PredicateType
//
//    func create(_ object: ObjectType)
//    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType?, limit: Int?) -> Result<[ObjectType], Error>
//    func fetchFirst(_ objectType: ObjectType.Type, predicate: PredicateType?) -> Result<ObjectType?, Error>
//    func update(_ object: ObjectType)
//    func delete(_ object: ObjectType)
//}
//
//public extension DatabaseProtocol {
//    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType? = nil, limit: Int? = nil) -> Result<[ObjectType], Error> {
//        return fetch(objectType, predicate: predicate, limit: limit)
//    }
//}
