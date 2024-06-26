//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import Combine
import CoreData
import CoreText
import SwiftData
import ZipArchive

public final class ManaKit {
    
    // MARK: - Constants
    
    public struct Font {
        public var name: String
        public var size: Double
    }
    
    public enum Fonts {
        public static let preEightEdition      = Font(name: "Magic:the Gathering", size: 17.0)
        public static let preEightEditionSmall = Font(name: "Magic:the Gathering", size: 15.0)
        public static let eightEdition         = Font(name: "Matrix-Bold", size: 18.0)
        public static let eightEditionSmall    = Font(name: "Matrix-Bold", size: 16.0)
        public static let magic2015            = Font(name: "Beleren", size: 16.0)
        public static let magic2015Small       = Font(name: "Beleren", size: 14.0)
    }

    public enum Constants {
        public static let eightEditionRelease  = "2003-07-28"
        public static let cacheAge             = 60 // 60 mins
        public static let keyruneURL           = "https://github.com/andrewgioia/Keyrune/archive/master.zip"
        public static let keyruneCacheAge      = 30 // 30 days
    }
    
    public enum ImageName: String {
        case cardCircles                       = "Card_Circles",
             cardBackCropped                   = "cardback-crop-hq",
             cardBack                          = "cardback-hq",
             collectorsCardBack                = "collectorscardback-hq",
             cropBack                          = "cropback-hq",
             grayPatterned                     = "Gray_Patterned_BG",
             intlCollectorsCardBack            = "internationalcollectorscardback-hq",
             mtgLogo                           = "mtg-logo"
    }
    
    public enum UserDefaultsKeys {
        public static let ScryfallDate         = "ScryfallDate"
        public static let KeyruneVersion       = "KeyruneVersion"
        public static let MTGJSONVersion       = "kMTGJSONVersion"
    }
    
    public enum Notifications {
        public static let fontsLoaded          = "fontsLoaded"
    }

    enum StorageType {
        case coreData, swiftData
    }

    
    let fontFiles = ["beleren-bold-webfont",
                     "belerensmallcaps-bold-webfont",
                     "Goudy Medieval",
                     "Matrix Bold",
                     "MPlantin"]

    // MARK: - Variables

    let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")
    var apiURL = ""
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Shared Instance
    
    public static let shared = ManaKit()

    // MARK: - Initializers
    
    private init() {
        let _ = persistentContainer
    }

    
    // MARK: - Resource methods
    
    public func configure(apiURL: String) {
        self.apiURL = apiURL
    }
    
//    public func nibFromBundle(_ name: String) -> UINib? {
//        let bundle = Bundle(for: ManaKit.self)
//        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
//            let resourceBundle = Bundle(url: bundleURL) else {
//            return nil
//        }
//
//        return UINib(nibName: name, bundle: resourceBundle)
//    }
    
    public func setupResources() async {
//        copyModelFile()
        copyDatabaseFile()
        await downloadKeyruneFont()
    }
    
    func downloadKeyruneFont() async {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        let keyrunePath = "\(cachePath)/keyrune-master"
        var willDownload = false
        
        do {
            if FileManager.default.fileExists(atPath: keyrunePath) {
                let attributes = try FileManager.default.attributesOfItem(atPath: keyrunePath)
                
                if let creationDate = attributes[FileAttributeKey.creationDate] as? Date,
                    let diff = Calendar.current.dateComponents([.day],
                                                              from: creationDate,
                                                              to: Date()).day {
                    willDownload = diff >= Constants.keyruneCacheAge
                }
            } else {
                willDownload = true
            }
            
            guard let url = URL(string: Constants.keyruneURL) else {
                return
            }
            
            if willDownload {
                // Remove the old files
                if FileManager.default.fileExists(atPath: keyrunePath) {
                    for file in try FileManager.default.contentsOfDirectory(atPath: keyrunePath) {
                        let path = "\(keyrunePath)/\(file)"
                        try FileManager.default.removeItem(atPath: path)
                    }
                    try FileManager.default.removeItem(atPath: keyrunePath)
                }

                let (localURL, _) = try await URLSession.shared.download(from: url)
                SSZipArchive.unzipFile(atPath: localURL.path, toDestination: cachePath)
                
                let fontURL = URL(fileURLWithPath: "\(keyrunePath)/fonts/keyrune.ttf")
                self.loadCustomFonts(and: fontURL)

            } else {
                let fontURL = URL(fileURLWithPath: "\(keyrunePath)/fonts/keyrune.ttf")
                loadCustomFonts(and: fontURL)
            }
        } catch {
            print(error)
            return
        }
    }

    func copyDatabaseFile() {
        let bundle = Bundle(for: ManaKit.self)

        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL),
            let appSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                                     .userDomainMask,
                                                                     true).first,
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                .userDomainMask,
                                                                true).first,
            let sourcePath = resourceBundle.path(forResource: "ManaKit.sqlite",
                                                 ofType: "zip"),
            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return
        }
        
        let targetPath = "\(appSupportPath)/\(bundleName).sqlite"

        if needsUpgrade() {
//            print("Copying database file: \(Constants.ScryfallDate)")
            
            // Shutdown database
//            dataStack = nil
//            persistentContainer = nil

            // Remove old database files in docs directory
            for file in try! FileManager.default.contentsOfDirectory(atPath: appSupportPath) {
                let path = "\(appSupportPath)/\(file)"
                if file.hasPrefix(bundleName) {
                    try! FileManager.default.removeItem(atPath: path)
                }
            }
            
            // remove the contents of crop directory
//            let cropPath = "\(cachePath)/crop/"
//            if FileManager.default.fileExists(atPath: cropPath) {
//                for file in try! FileManager.default.contentsOfDirectory(atPath: cropPath) {
//                    let path = "\(cropPath)/\(file)"
//                    try! FileManager.default.removeItem(atPath: path)
//                }
//            }

            // delete image cache
//            let imageCache = SDImageCache.init()
//            imageCache.clearDisk(onCompletion: nil)
            
            // Unzip
            SSZipArchive.unzipFile(atPath: sourcePath,
                                   toDestination: appSupportPath)
            
            // rename
            try! FileManager.default.moveItem(atPath: "\(appSupportPath)/ManaKit.sqlite",
                                              toPath: targetPath)
            
            // skip from iCloud backups!
//            var targetURL = URL(fileURLWithPath: targetPath)
//            var resourceValues = URLResourceValues()
//            resourceValues.isExcludedFromBackup = true
//            try! targetURL.setResourceValues(resourceValues)
            
//            UserDefaults.standard.set(Constants.ScryfallDate,
//                                      forKey: UserDefaultsKeys.ScryfallDate)
//            UserDefaults.standard.synchronize()
        }
    }

    func needsUpgrade() -> Bool {
        var willUpgrade = true
        
        if let scryfallDate = UserDefaults.standard.string(forKey: UserDefaultsKeys.ScryfallDate) {
//            if scryfallDate == Constants.ScryfallDate {
                willUpgrade = false
//            }
        }
        
        return willUpgrade
    }
    
    func loadCustomFonts(and url: URL) {
        var urls = [URL]()
        
        for font in fontFiles {
            if let path = Bundle.module.path(forResource: font, ofType: "ttf") {
                urls.append(URL(fileURLWithPath: path))
            }
        }
        urls.append(url)
        
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
        
        NotificationCenter.default.post(name: Notification.Name(Notifications.fontsLoaded), object: nil)
    }
    
    // MARK: - Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource:"ManaKit", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Can't load persistent container")
        }
        
        let container = NSPersistentContainer(name: "ManaKit", managedObjectModel: model)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

//        if inMemory {
//            description.url = URL(fileURLWithPath: "/dev/null")
//        }

        description.setOption(true as NSNumber,
                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        description.setOption(true as NSNumber,
                              forKey: NSPersistentHistoryTrackingKey)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.automaticallyMergesChangesFromParent = false
//        container.viewContext.name = "viewContext"
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.undoManager = nil
//        container.viewContext.shouldDeleteInaccessibleFaults = true

        return container
    }()
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil

        return context
    }
}
