//
//  ManakitUtilities.swift
//  ManaKit
//
//  Created by Vito Royeca on 4/11/26.
//
import Foundation
import CoreText

import Apollo
import ZipArchive

@MainActor
public class ManaKitUtilities {
    public struct Font {
        public var name: String
        public var size: Double
    }
    
    public enum Fonts {
        @MainActor public static let preEightEdition      = Font(name: "Magic:the Gathering", size: 17.0)
        @MainActor public static let preEightEditionSmall = Font(name: "Magic:the Gathering", size: 15.0)
        @MainActor public static let eightEdition         = Font(name: "Matrix-Bold", size: 18.0)
        @MainActor public static let eightEditionSmall    = Font(name: "Matrix-Bold", size: 16.0)
        @MainActor public static let magic2015            = Font(name: "Beleren", size: 16.0)
        @MainActor public static let magic2015Small       = Font(name: "Beleren", size: 14.0)
    }

    public enum Constants {
        public static let eightEditionRelease  = "2003-07-28"
        public static let cacheAge             = 60 // 60 mins
        public static let keyruneSymbolURL     = "https://github.com/andrewgioia/keyrune/archive/master.zip"
        public static let manaSymbolURL        = "https://github.com/andrewgioia/mana/archive/master.zip"
        public static let symbolCacheAge       = 30 // 30 days
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

    public static let shared = ManaKitUtilities()
    
    let fontFiles = [
        "beleren-bold-webfont",
        "belerensmallcaps-bold-webfont",
        "Goudy Medieval",
        "keyrune",
        "mana",
        "Matrix Bold",
        "mplantin"
    ]
    
    // MARK: - Appollo GraphQL
    lazy var apollo = ApolloClient(url: URL(string: apiURL)!)
//    private(set) public lazy var apolloSQLite: ApolloClient = {
//        do {
//            let documentsPath = try FileManager.default.url(for: .documentDirectory,
//                                                            in: .userDomainMask,
//                                                            appropriateFor: nil,
//                                                            create: false)
//            let fileUrl = documentsPath.appendingPathComponent("ManaKit_apollo.sqlite")
//
//            let sqliteCache = try SQLiteNormalizedCache(fileURL: fileUrl)
//
//            let store = ApolloStore(cache: sqliteCache)
//
//            let transport = RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: store),
//                                                         endpointURL: URL(string: apiURL)!)
//
//            return ApolloClient(networkTransport: transport, store: store)
//        } catch {
//            print("Error creating ApolloSQLite Client: \(error)")
//            return apollo
//        }
//    }()
    
    
    // MARK: - Initializer
    private var apiURL = ""
    
    public func configure(apiURL: String) {
        self.apiURL = apiURL
    }
    
    // MARK: - Utility methods

    public func downloadSymbolsFont() async {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        let fonts = [
            [
                "name": "keyrune",
                "localPath": "\(cachePath)/keyrune-master",
                "remotePath": Constants.keyruneSymbolURL,
            ],
            [
                "name": "mana",
                "localPath": "\(cachePath)/mana-master",
                "remotePath": Constants.manaSymbolURL,
            ]
        ]
        var willDownload = false
        
        for font in fonts {
            if let name = font["name"],
               let localPath = font["localPath"],
               let remotePath = font["remotePath"],
               let remoteUrl = URL(string: remotePath) {
                
                do {
                    if FileManager.default.fileExists(atPath: localPath) {
                        let attributes = try FileManager.default.attributesOfItem(atPath: localPath)
                        let lastDownloaded = UserDefaults().object(forKey: "\(name)_lastDownloaded") as? Foundation.Date
                            ?? Foundation.Date()

                        if let creationDate = attributes[FileAttributeKey.creationDate] as? Foundation.Date,
                           let diff = Calendar.current.dateComponents([.day],
                                                                      from: Foundation.Date(),
                                                                      to: lastDownloaded).day {
                            willDownload = diff >= Constants.symbolCacheAge
                        }
                    } else {
                        willDownload = true
                    }
                    
                    if willDownload {
                        // Remove the old files
                        if FileManager.default.fileExists(atPath: localPath) {
                            for file in try FileManager.default.contentsOfDirectory(atPath: localPath) {
                                let path = "\(localPath)/\(file)"
                                try FileManager.default.removeItem(atPath: path)
                            }
                            try FileManager.default.removeItem(atPath: localPath)
                        }
                        
                        let (localURL, _) = try await URLSession.shared.download(from: remoteUrl)
                        SSZipArchive.unzipFile(atPath: localURL.path, toDestination: cachePath)

                        // record the download date
                        UserDefaults().set(Foundation.Date(), forKey: "\(name)_lastDownloaded")
                    }
                    
                    // unload bundled font
                    if let bundlePath = Bundle.module.path(forResource: name, ofType: "ttf") {
                        let url = URL(fileURLWithPath: bundlePath)
                        unloadCustomFont(url: url)
                    }
                    
                    // find all .ttf files and load them
                    for file in try FileManager.default.contentsOfDirectory(atPath: "\(localPath)/fonts") {
                        if file.hasSuffix(".ttf") {
                            let url = URL(fileURLWithPath: "\(localPath)/fonts/\(file)")
                            loadCustomFont(url: url)
                        }
                    }
                } catch {
                    print(error)
                }
            }
            willDownload = false
        }
    }
    
    public func loadCustomFonts() {
        for font in fontFiles {
            if let path = Bundle.module.path(forResource: font, ofType: "ttf") {
                let url = URL(fileURLWithPath: path)
                loadCustomFont(url: url)
            }
        }
    }
    
    func loadCustomFont(url: URL) {
        if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) {
            print("Failed to register font at: \(url)")
        }
    }
    
    func unloadCustomFont(url: URL) {
        if !CTFontManagerUnregisterFontsForURL(url as CFURL, .process, nil) {
            print("Failed to unregister font at: \(url)")
        }
    }
}

