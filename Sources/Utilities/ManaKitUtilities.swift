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

    public static let shared = ManaKitUtilities()
    
    let fontFiles = [
        "beleren-bold-webfont",
        "belerensmallcaps-bold-webfont",
        "Goudy Medieval",
        "Matrix Bold",
        "MPlantin"
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

    public func downloadKeyruneFont() async {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        let keyrunePath = "\(cachePath)/keyrune-master"
        var willDownload = false
        
        do {
            if FileManager.default.fileExists(atPath: keyrunePath) {
                let attributes = try FileManager.default.attributesOfItem(atPath: keyrunePath)
                
                if let creationDate = attributes[FileAttributeKey.creationDate] as? Foundation.Date,
                    let diff = Calendar.current.dateComponents([.day],
                                                               from: creationDate,
                                                               to: Foundation.Date()).day {
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
    
    func loadCustomFonts(and url: URL) {
        var urls = [URL]()
        
        for font in fontFiles {
            if let path = Bundle.module.path(forResource: font, ofType: "ttf") {
                urls.append(URL(fileURLWithPath: path))
            }
        }
        urls.append(url)
        
        for url in urls {
            if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) {
                print("Failed to register font at: \(url)")
            }
        }
        
//        NotificationCenter.default.post(name: Notification.Name(Notifications.fontsLoaded), object: nil)
    }
}
