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
import RealmSwift
import SDWebImage
import SSZipArchive

public class ManaKit {
    public enum Fonts {
        public static let preEightEdition      = UIFont(name: "Magic:the Gathering", size: 17.0)
        public static let preEightEditionSmall = UIFont(name: "Magic:the Gathering", size: 15.0)
        public static let eightEdition         = UIFont(name: "Matrix-Bold", size: 17.0)
        public static let eightEditionSmall    = UIFont(name: "Matrix-Bold", size: 15.0)
        public static let magic2015            = UIFont(name: "Beleren", size: 17.0)
        public static let magic2015Small       = UIFont(name: "Beleren", size: 15.0)
    }

    public enum PriceColors {
        public static let low    = UIColor.red
        public static let mid    = UIColor.blue
        public static let high   = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
        public static let foil   = UIColor(red:0.60, green:0.51, blue:0.00, alpha:1.0)
        public static let normal = UIColor.black
    }
    
    public enum Constants {
        public static let ScryfallDate        = "2019-01-12 09:23 UTC"
        public static let KeyruneVersion      = "3.3.3"
        public static let EightEditionRelease = "2003-07-28"
        public static let TcgPlayerApiVersion = "v1.9.0"
        public static let TcgPlayerApiLimit   = 300
        public static let TcgPlayerPricingAge = 24 * 3 // 3 days
        
        public static let FirebaseDataAge     = 60     // 60 sec
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
        public static let ScryfallDate     = "ScryfallDate"
        public static let MTGJSONVersion   = "kMTGJSONVersion"
        public static let TcgPlayerToken   = "TcgPlayerToken"
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
    
    var _realm: Realm?
    public var realm: Realm {
        get {
            if _realm == nil {
                guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
                    fatalError("Can't find bundleName")
                }
                var config = Realm.Configuration()
                
                
                // Use the default directory, but replace the filename with ManaKit
                config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(bundleName).realm")
                
                // Set this as the configuration used for the default Realm
                Realm.Configuration.defaultConfiguration = config
                
                // Open the Realm with the configuration
                _realm = try! Realm(configuration: config)
            }
            return _realm!
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
    
    func copyDatabaseFile() {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL),
            let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
            let sourcePath = resourceBundle.path(forResource: "ManaKit.realm", ofType: "zip"),
            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return
        }
        let targetPath = "\(docsPath)/\(bundleName).realm"
        var willCopy = true

        if let scryfallDate = UserDefaults.standard.string(forKey: UserDefaultsKeys.ScryfallDate) {
            if scryfallDate == Constants.ScryfallDate {
                willCopy = false
            }
        }

        if willCopy {
            print("Copying database file: \(Constants.ScryfallDate)")

            // Remove old database files in docs directory
            for file in try! FileManager.default.contentsOfDirectory(atPath: docsPath) {
                let path = "\(docsPath)/\(file)"
                if file.hasPrefix(bundleName) {
                    try! FileManager.default.removeItem(atPath: path)
                }
            }
            
            // remove the contents of crop directory
            let cropPath = "\(cachePath)/crop/"
            if FileManager.default.fileExists(atPath: cropPath) {
                for file in try! FileManager.default.contentsOfDirectory(atPath: cropPath) {
                    let path = "\(cropPath)/\(file)"
                    try! FileManager.default.removeItem(atPath: path)
                }
            }

            // delete image cache
            let imageCache = SDImageCache.init()
            imageCache.clearDisk(onCompletion: nil)
            
            // Unzip
            SSZipArchive.unzipFile(atPath: sourcePath, toDestination: docsPath)
            
            // rename
            try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.realm", toPath: targetPath)
            
            // skip from iCloud backups!
            var targetURL = URL(fileURLWithPath: targetPath)
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try! targetURL.setResourceValues(resourceValues)
            
            UserDefaults.standard.set(Constants.ScryfallDate, forKey: UserDefaultsKeys.ScryfallDate)
            UserDefaults.standard.synchronize()
        }
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
    
    // MARK: Image methods
    public func imageFromFramework(imageName: ImageName) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL) else {
                return nil
        }
        
        return UIImage(named: imageName.rawValue, in: resourceBundle, compatibleWith: nil)
    }
    
    public func symbolImage(name: String) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL) else {
                return nil
        }
        
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
    
    public func downloadImage(ofCard card: CMCard, type: CardImageType, faceOrder: Int) -> Promise<Void> {
        guard let url = card.imageURL(type: type,
                                      faceOrder: faceOrder) else {
            
            return Promise { seal  in
                let error = NSError(domain: NSURLErrorDomain,
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "No valid URL for image"])
                seal.reject(error)
            }
        }
        
        let roundCornered = type != .artCrop
        
        if let _ = card.image(type: type,
                              faceOrder: faceOrder,
                              roundCornered: roundCornered) {
            return Promise { seal  in
                seal.fulfill(())
            }
        } else {
            return downloadImage(url: url)
        }
    }
    
    public func downloadImage(url: URL) -> Promise<Void> {
        return Promise { seal in
            let downloader = SDWebImageDownloader.shared()
            let cacheKey = url.absoluteString
            let completion = { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
                if let error = error {
                    seal.reject(error)
                } else {
                    if let image = image {
                        let imageCache = SDImageCache.init()
                        let imageCacheCompletion = {
                            seal.fulfill(())
                        }
                        
                        imageCache.store(image,
                                         forKey: cacheKey,
                                         toDisk: true,
                                         completion: imageCacheCompletion)
                        
                    } else {
                        let error = NSError(domain: NSURLErrorDomain,
                                            code: 404,
                                            userInfo: [NSLocalizedDescriptionKey: "Image not found: \(url)"])
                        seal.reject(error)
                    }
                }
            }
            
            downloader.downloadImage(with: url,
                                     options: .lowPriority,
                                     progress: nil,
                                     completed: completion)
        }
    }
    
    // MARK: TCGPlayer
    public func configureTcgPlayer(partnerKey: String, publicKey: String?, privateKey: String?) {
        tcgPlayerPartnerKey = partnerKey
        tcgPlayerPublicKey = publicKey
        tcgPlayerPrivateKey = privateKey
    }
    
    public func authenticateTcgPlayer() -> Promise<Void> {
        return Promise { seal  in
            guard let _ = tcgPlayerPartnerKey,
                let tcgPlayerPublicKey = tcgPlayerPublicKey,
                let tcgPlayerPrivateKey = tcgPlayerPrivateKey else {
                let error = NSError(domain: "Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "No TCGPlayer keys found."])
                seal.reject(error)
                return
            }
            
            if let _ = keychain[UserDefaultsKeys.TcgPlayerToken] {
                seal.fulfill(())
            } else {
                guard let urlString = "https://api.tcgplayer.com/token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    fatalError("Malformed url")
                }
                let query = "grant_type=client_credentials&client_id=\(tcgPlayerPublicKey)&client_secret=\(tcgPlayerPrivateKey)"
            
                var rq = URLRequest(url: url)
                rq.httpMethod = "POST"
                rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                rq.httpBody = query.data(using: .utf8)
            
                firstly {
                    URLSession.shared.dataTask(.promise, with: rq)
                }.compactMap {
                    try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
                }.done { json in
                    guard let token = json["access_token"] as? String else {
                        let error = NSError(domain: "Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "No TCGPlayer token found."])
                        seal.reject(error)
                        return
                    }
                    self.keychain[UserDefaultsKeys.TcgPlayerToken] = token
                    seal.fulfill()
                }.catch { error in
                    print("\(error)")
                    seal.reject(error)
                }
            }
        }
    }
    
    public func getTcgPlayerPrices(forSet set: CMSet) -> Promise<Void> {
        return Promise { seal  in
            guard let urlString = "http://api.tcgplayer.com/\(Constants.TcgPlayerApiVersion)/pricing/group/\(set.tcgPlayerID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                    fatalError("Malformed url")
            }
            
            guard let token = keychain[UserDefaultsKeys.TcgPlayerToken] else {
                fatalError("No TCGPlayer token found.")
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                guard let results = json["results"] as? [[String: Any]] else {
                    fatalError("results is nil")
                }
                
                try! self.realm.write {
                    // delete first
                    for card in set.cards {
                        for pricing in card.pricings {
                            self.realm.delete(pricing)
                        }
                        self.realm.add(card)
                    }
                    
                    for dict in results {
                        if let productId = dict["productId"] as? Int,
                            let card = self.realm.objects(CMCard.self).filter("tcgPlayerID = %@", productId).first {
                            
                            let pricing = CMCardPricing()
                            pricing.card = card
                            if let d = dict["lowPrice"] as? Double {
                                pricing.lowPrice = d
                            }
                            if let d = dict["midPrice"] as? Double {
                                pricing.midPrice = d
                            }
                            if let d = dict["highPrice"] as? Double {
                                pricing.highPrice = d
                            }
                            if let d = dict["marketPrice"] as? Double {
                                pricing.marketPrice = d
                            }
                            if let d = dict["directLowPrice"] as? Double {
                                pricing.directLowPrice = d
                            }
                            if let d = dict["subTypeName"] as? String {
                                if d == "Normal" {
                                    pricing.isFoil = false
                                } else if d == "Foil" {
                                    pricing.isFoil = true
                                }
                            }
                            self.realm.add(pricing)
                            
                            card.pricings.append(pricing)
                            card.tcgPlayerID = Int32(productId)
                            card.tcgPlayerLstUpdate = Date()
                            self.realm.add(card)
                        }
                    }
                    seal.fulfill()
                }
            }.catch { error in
                print("\(error)")
                seal.reject(error)
            }
        }
    }
    
    public func getTcgPlayerPrices(forCards cards: [CMCard]) -> Promise<Void> {
        return Promise { seal  in
            let productIds = cards.map({ $0.tcgPlayerID }).map(String.init).joined(separator: ",")
            guard let urlString = "http://api.tcgplayer.com/\(Constants.TcgPlayerApiVersion)/pricing/product/\(productIds)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                fatalError("Malformed url")
            }
            
            guard let token = keychain[UserDefaultsKeys.TcgPlayerToken] else {
                fatalError("No TCGPlayer token found.")
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            rq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
            }.done { json in
                guard let results = json["results"] as? [[String: Any]] else {
                    fatalError("results is nil")
                }
                
                try! self.realm.write {
                    // delete first
                    for card in cards {
                        for pricing in card.pricings {
                            self.realm.delete(pricing)
                        }
                        self.realm.add(card)
                    }
                    
                    for dict in results {
                        if let productId = dict["productId"] as? Int,
                            let card = cards.filter({ it -> Bool in
                               it.tcgPlayerID == productId
                            }).first {
                            
                            let pricing = CMCardPricing()
                            pricing.card = card
                            if let d = dict["lowPrice"] as? Double {
                                pricing.lowPrice = d
                            }
                            if let d = dict["midPrice"] as? Double {
                                pricing.midPrice = d
                            }
                            if let d = dict["highPrice"] as? Double {
                                pricing.highPrice = d
                            }
                            if let d = dict["marketPrice"] as? Double {
                                pricing.marketPrice = d
                            }
                            if let d = dict["directLowPrice"] as? Double {
                                pricing.directLowPrice = d
                            }
                            if let d = dict["subTypeName"] as? String {
                                if d == "Normal" {
                                    pricing.isFoil = false
                                } else if d == "Foil" {
                                    pricing.isFoil = true
                                }
                            }
                            self.realm.add(pricing)
                            
                            card.pricings.append(pricing)
                            card.tcgPlayerID = Int32(productId)
                            card.tcgPlayerLstUpdate = Date()
                            self.realm.add(card)
                        }
                    }
                    seal.fulfill()
                }
            }.catch { error in
                print("\(error)")
                seal.reject(error)
            }
        }
    }
    
/*
    public func fetchTCGPlayerCardPricing(card: CMCard) -> Promise<Void> {
        return Promise { seal  in
            if card.willUpdateTCGPlayerCardPricing() {
                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
//                    let set = card.set,
//                    let tcgPlayerSetName = set.tcgplayerName,
                    let cardName = card.name,
                    let urlString = "http://partner.tcgplayer.com/x3/phl.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\("tcgPlayerSetName")&p=\(cardName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    
                    seal.fulfill(())
                    return
                }
                
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
                
                firstly {
                    URLSession.shared.dataTask(.promise, with: rq)
                }.map {
                    try! XML(xml: $0.data, encoding: .utf8)
                }.done { xml in
                    let pricing = card.pricing != nil ? card.pricing : CMCardPricing()
                    
                    try! self.realm.write {
                        for product in xml.xpath("//product") {
                            if let id = product.xpath("id").first?.text,
                                let hiprice = product.xpath("hiprice").first?.text,
                                let lowprice = product.xpath("lowprice").first?.text,
                                let avgprice = product.xpath("avgprice").first?.text,
                                let foilavgprice = product.xpath("foilavgprice").first?.text,
                                let link = product.xpath("link").first?.text {
                                pricing!.id = Int64(id)!
                                pricing!.high = Double(hiprice)!
                                pricing!.low = Double(lowprice)!
                                pricing!.average = Double(avgprice)!
                                pricing!.foil = Double(foilavgprice)!
                                pricing!.link = link
                            }
                        }
                        pricing!.lastUpdate = Date()
                        card.pricing = pricing
                    
                        self.realm.add(pricing!)
                        self.realm.add(card, update: true)
                        seal.fulfill(())
                    }
                }.catch { error in
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
*/
    public func fetchTCGPlayerStorePricing(card: CMCard) -> Promise<Void> {
        return Promise { seal  in
            if card.willUpdateTCGPlayerStorePricing() {
                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
//                    let set = card.set,
//                    let tcgPlayerSetName = set.tcgplayerName,
                    let cardName = card.name,
                    let urlString = "http://partner.tcgplayer.com/x3/pv.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\("tcgPlayerSetName")&p=\(cardName)&v=8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) else {
                    
                    seal.fulfill(())
                    return
                }
                
                var rq = URLRequest(url: url)
                rq.httpMethod = "GET"
            
                firstly {
                    URLSession.shared.dataTask(.promise, with: rq)
                }.map {
                    try! XML(xml: $0.data, encoding: .utf8)
                }.done { xml in
                    try! self.realm.write {
                        var storePricing: CMStorePricing?
                        
                        // cleanup existing storePricing, if there is any
                        if let sp = card.tcgplayerStorePricing {
                            for sup in sp.suppliers {
                                self.realm.delete(sup)
                            }
                            self.realm.delete(sp)
                            storePricing = sp
                        } else {
                            storePricing = CMStorePricing()
                        }
                        
                        for supplier in xml.xpath("//supplier") {
                            if let name = supplier.xpath("name").first?.text,
                                let condition = supplier.xpath("condition").first?.text,
                                let qty = supplier.xpath("qty").first?.text,
                                let price = supplier.xpath("price").first?.text,
                                let link = supplier.xpath("link").first?.text {
                                
                                let id = "\(name)_\(condition)_\(qty)_\(price)"
                                var sup: CMStoreSupplier?
                                
                                if let s = self.realm.objects(CMStoreSupplier.self).filter("id = %@", id).first {
                                    sup = s
                                } else {
                                    sup = CMStoreSupplier()
                                }
                                sup!.id = id
                                sup!.name = name
                                sup!.condition = condition
                                sup!.qty = Int32(qty)!
                                sup!.price = Double(price)!
                                sup!.link = link
                                self.realm.add(sup!)
                                storePricing!.suppliers.append(sup!)
                            }
                        }
                        if let note = xml.xpath("//note").first?.text {
                            storePricing!.notes = note
                        }
                        storePricing!.lastUpdate = Date()
                        self.realm.add(storePricing!)
                        
                        seal.fulfill(())
                    }
                    
                }.catch { error in
                    seal.reject(error)
                }
            } else {
                seal.fulfill(())
            }
        }
    }
    
    // MARK: Firebase
    public func newFirebaseKey(from oldFirebaseKey: String) -> String {
        var parts = oldFirebaseKey.components(separatedBy: "_")
        var numComponent = ""
        let capName = parts[1]
        
        if parts.filter({ (isIncluded) -> Bool in
            return isIncluded.lowercased().hasPrefix(capName.lowercased())
        }).count > 1 {
            numComponent = parts.remove(at: 2)
            numComponent = numComponent.replacingOccurrences(of: capName.lowercased(), with: "")
        }
        
        var newKey = parts.joined(separator: "_")
        if !numComponent.isEmpty {
            newKey = "\(newKey)_\(numComponent)"
        }
        return encodeFirebase(key: newKey)
    }
    
    public func encodeFirebase(key: String) -> String {
        return key.replacingOccurrences(of: ".", with: "P%n*")
            .replacingOccurrences(of: "$", with: "D%n*")
            .replacingOccurrences(of: "#", with: "H%n*")
            .replacingOccurrences(of: "[", with: "On%*")
            .replacingOccurrences(of: "]", with: "n*C%")
            .replacingOccurrences(of: "/", with: "*S%n")
    }
    
    public func decodeFirebase(key: String) -> String {
        return key.replacingOccurrences(of: "P%n*", with: ".")
            .replacingOccurrences(of: "D%n*", with: "$")
            .replacingOccurrences(of: "H%n*", with: "#")
            .replacingOccurrences(of: "On%*", with: "[")
            .replacingOccurrences(of: "n*C%", with: "]")
            .replacingOccurrences(of: "*S%n", with: "/")
    }
}
