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
import ZipArchive

public final class ManaKit: NSPersistentContainer {
    
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
        public static let cacheAge             = 5 // 5 mins
        public static let keyruneURL           = "https://github.com/andrewgioia/Keyrune/archive/master.zip"
        public static let keyruneCacheAge      = 1 // 1 day
    }
    
    public enum ImageName: String {
        case cardCircles                       = "images/Card_Circles",
             cardBackCropped                   = "images/cardback-crop-hq",
             cardBack                          = "images/cardback-hq",
             collectorsCardBack                = "images/collectorscardback-hq",
             cropBack                          = "images/cropback-hq",
             grayPatterned                     = "images/Gray_Patterned_BG",
             intlCollectorsCardBack            = "images/internationalcollectorscardback-hq"
    }
    
    public enum UserDefaultsKeys {
        public static let ScryfallDate         = "ScryfallDate"
        public static let KeyruneVersion       = "KeyruneVersion"
        public static let MTGJSONVersion       = "kMTGJSONVersion"
    }
    
    public enum Notifications {
        public static let fontsLoaded          = "fontsLoaded"
    }
    
    // MARK: - Variables

    var apiURL = ""
//    var isMemory = false
    let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")

    // MARK: - Shared Instance
    
    public static let shared = ManaKit()
    
    // MARK: - Initializers
    
    private init() {
        guard let modelURL = Bundle.module.url(forResource:"ManaKit", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Can't load persistent container")
        }
        super.init(name: "ManaKit", managedObjectModel: model)
        
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
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
    
    public func setupResources() {
//        copyModelFile()
//        copyDatabaseFile()
//        loadCustomFonts()
        downloadKeyruneFont()
    }
    
    func downloadKeyruneFont() {
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

                let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
                    if let localURL = localURL {
                        SSZipArchive.unzipFile(atPath: localURL.path, toDestination: cachePath)
                        
                        let fontURL = URL(fileURLWithPath: "\(keyrunePath)/fonts/keyrune.ttf")
                        self.loadCustomFonts(and: fontURL)
                    }
                }

                task.resume()
            } else {
                let fontURL = URL(fileURLWithPath: "\(keyrunePath)/fonts/keyrune.ttf")
                loadCustomFonts(and: fontURL)
            }
        } catch {
            print(error)
            return
        }
    }

    func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
    }
    
    func loadCustomFonts(and url: URL) {
        let fonts = ["beleren-bold-webfont.ttf",
                     "belerensmallcaps-bold-webfont.ttf",
                     "Goudy Medieval.ttf",
                     "Matrix Bold.ttf",
                     "MPlantin.ttf"]
        var urls = [URL]()
        
        for font in fonts {
            if let path = Bundle.module.path(forResource: font, ofType: nil) {
                urls.append(URL(fileURLWithPath: path))
            }
        }
        urls.append(url)
        
//        let bundle = Bundle(for: ManaKit.self)
//
//        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
//            let resourceBundle = Bundle(url: bundleURL),
//            let fontUrls = resourceBundle.urls(forResourcesWithExtension: "ttf", subdirectory: "fonts") else {
//            return
//        }
//
//        var newUrls = [URL](fontUrls)
//        newUrls.append(url)
        
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
    
    // MARK: - Core Data
    
    /*public lazy var persistentContainer: NSPersistentContainer = {
//        let bundle = Bundle(for: ManaKit.self)
//
//        guard let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
//           let managedObjectModel = NSManagedObjectModel(contentsOf: momURL) else {
//            fatalError("Can't load persistent container")
//        }
//
//        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "ManaKit"
//        let container = NSPersistentContainer(name: bundleName, managedObjectModel: managedObjectModel)
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//
//        return container
        
        guard let modelURL = Bundle.module.url(forResource:"ManaKit", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Can't load persistent container")
        }

        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "ManaKit"
        let container = NSPersistentContainer(name: bundleName, managedObjectModel: model)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return container
    }()*/
    
    
}
