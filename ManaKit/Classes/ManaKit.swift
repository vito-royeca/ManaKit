//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import Kanna
import KeychainAccess
import PromiseKit
import SDWebImage
import Sync

public class ManaKit {
    public enum Fonts {
        public static let preEightEdition      = UIFont(name: "Magic:the Gathering", size: 17.0)
        public static let preEightEditionSmall = UIFont(name: "Magic:the Gathering", size: 15.0)
        public static let eightEdition         = UIFont(name: "Matrix-Bold", size: 17.0)
        public static let eightEditionSmall    = UIFont(name: "Matrix-Bold", size: 15.0)
        public static let magic2015            = UIFont(name: "Beleren", size: 17.0)
        public static let magic2015Small       = UIFont(name: "Beleren", size: 15.0)
    }

    public enum Constants {
        public static let ScryfallDate        = "2019-12-09 10:23 UTC"
        public static let EightEditionRelease = "2003-07-28"
        public static let ManaGuideDataAge    = 24 * 3 // 3 days
        public static let TcgPlayerApiVersion = "v1.19.0"
        public static let TcgPlayerApiLimit   = 300
        public static let TcgPlayerPricingAge = 24 * 3 // 3 days
        public static let FirebaseDataAge     = 60     // 60 sec
        public static let APIURL              = "http://192.168.1.182:1993"
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
    public static let sharedInstance = ManaKit()
    
    // MARK: Variables
    var tcgPlayerPartnerKey: String?
    var tcgPlayerPublicKey: String?
    var tcgPlayerPrivateKey: String?
    
    var _keyChain: Keychain?
    var keychain: Keychain {
        get {
            if _keyChain == nil {
                _keyChain = Keychain(service: "com.jovitoroyeca.ManaKit")
            }
            return _keyChain!
        }
    }
    
    // MARK: Public variables
    private var _dataStack: DataStack?
    public var dataStack: DataStack? {
        get {
            if _dataStack == nil {
                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle"),
                    let bundle = Bundle(url: bundleURL),
                    let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
                    let objectModel = NSManagedObjectModel(contentsOf: momURL) else {
                    return nil
                }
                _dataStack = DataStack(model: objectModel, storeType: .sqLite)
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }
    
    // MARK: Resource methods
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
    
    // MARK: Firebase
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
}
