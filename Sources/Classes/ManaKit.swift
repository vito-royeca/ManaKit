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

public class ManaKit: DatabaseProtocol {
    public enum Fonts {
        public static let preEightEdition      = UIFont(name: "Magic:the Gathering", size: 17.0)
        public static let preEightEditionSmall = UIFont(name: "Magic:the Gathering", size: 15.0)
        public static let eightEdition         = UIFont(name: "Matrix-Bold", size: 17.0)
        public static let eightEditionSmall    = UIFont(name: "Matrix-Bold", size: 15.0)
        public static let magic2015            = UIFont(name: "Beleren", size: 17.0)
        public static let magic2015Small       = UIFont(name: "Beleren", size: 15.0)
    }

    public enum Constants {
//        public static let ScryfallDate        = "2021-06-15 09:15 UTC"
        public static let EightEditionRelease = "2003-07-28"
        public static let ManaGuideDataAge    = 24 * 3 // 3 days
        public static let TcgPlayerApiVersion = "v1.36.0"
        public static let TcgPlayerApiLimit   = 300
        public static let TcgPlayerPricingAge = 24 * 3 // 3 days
        public static let TcgPlayerPublicKey  = "A49D81FB-5A76-4634-9152-E1FB5A657720"
        public static let TcgPlayerPrivateKey = "C018EF82-2A4D-4F7A-A785-04ADEBF2A8E5"
        public static let MomModel            = "2020-01-30.mom"
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
        public static let TcgPlayerToken        = "TcgPlayerToken"
        public static let TcgPlayerExpiration   = "TcgPlayerExpiration"
    }
    
    // MARK: - Shared Instance
    public static let shared = ManaKit()
    
    // MARK: - Variables
    var tcgPlayerPartnerKey: String?
    var tcgPlayerPublicKey: String?
    var tcgPlayerPrivateKey: String?
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
    
    // MARK: - Public variables
    /*private var _dataStack: DataStack?
    public var dataStack: DataStack? {
        get {
            if _dataStack == nil {
//                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle"),
//                    let bundle = Bundle(url: bundleURL),
//                    let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
//                    let objectModel = NSManagedObjectModel(contentsOf: momURL.appendingPathComponent("\(Constants.MomModel)")) else {
//                    return nil
//                }
                guard let modelURL = Bundle(for: type(of: self)).url(forResource: "ManaKit", withExtension: "momd"),
                      let objectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                    return nil
                }
                _dataStack = DataStack(model: objectModel, storeType: .sqLite)
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }*/
    
    private var _container: NSPersistentContainer?
    public var container: NSPersistentContainer? {
        get {
            if _container == nil {
                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle"),
                    let bundle = Bundle(url: bundleURL),
                    let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
                    let objectModel = NSManagedObjectModel(contentsOf: momURL.appendingPathComponent("\(Constants.MomModel)")) else {
                    return nil
                }
                _container = NSPersistentContainer(name: "ManaKit", managedObjectModel: objectModel)
            }
            return _container
        }
    }
    
    // MARK: - Resource methods
    
    public func configure(apiURL: String, partnerKey: String, publicKey: String?, privateKey: String?) {
        self.apiURL = apiURL
        tcgPlayerPartnerKey = partnerKey
        tcgPlayerPublicKey = publicKey
        tcgPlayerPrivateKey = privateKey
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
        copyDatabaseFile()
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
    
    public typealias ObjectType = NSManagedObject
    public typealias PredicateType = NSPredicate
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    public func create(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while creating an object")
        }
    }
    
    public func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            let result = try context.fetch(request)
            return .success(result as? [T] ?? [])
        } catch {
            return .failure(error)
        }
    }
    
    public func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let result = fetch(objectType, predicate: predicate, limit: 1)
        
        switch result {
        case .success(let objects):
            return .success(objects.first as? T)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func update(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while updating an object")
        }
    }

    public func delete(_ object: NSManagedObject) {

    }
    
    // MARK: - Core Data
    
    public lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "ManaKit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

public protocol DatabaseProtocol {
    associatedtype ObjectType
    associatedtype PredicateType
    
    func create(_ object: ObjectType)
    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType?, limit: Int?) -> Result<[ObjectType], Error>
    func fetchFirst(_ objectType: ObjectType.Type, predicate: PredicateType?) -> Result<ObjectType?, Error>
    func update(_ object: ObjectType)
    func delete(_ object: ObjectType)
}

public extension DatabaseProtocol {
    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType? = nil, limit: Int? = nil) -> Result<[ObjectType], Error> {
        return fetch(objectType, predicate: predicate, limit: limit)
    }
}
