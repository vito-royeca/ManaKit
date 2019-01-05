//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import Kanna
import PromiseKit
import RealmSwift
import SDWebImage
import SSZipArchive

@objc(ManaKit)
public class ManaKit: NSObject {
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
        public static let ScryfallDateKey     = "ScryfallDateKey"
        public static let ScryfallDate        = "2019-01-04 09:58 UTC"
        public static let KeyruneVersion      = "3.3.3"
        public static let EightEditionRelease = "2003-07-28"
        public static let TCGPlayerPricingAge = 24 * 3 // 3 days
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
    
    public enum ImageType: Int {
        case png
        case borderCrop
        case artCrop
        case large
        case normal
        case small
        
        var description : String {
            switch self {
            
            case .png: return "png"
            case .borderCrop: return "border_crop"
            case .artCrop: return "art_crop"
            case .large: return "large"
            case .normal: return "normal"
            case .small: return "small"
            }
        }
    }
    
    public enum UserDefaultsKeys {
        public static let MTGJSONVersionKey   = "kMTGJSONVersionKey"
    }
    
    // MARK: - Shared Instance
    public static let sharedInstance = ManaKit()
    
    // MARK: Variables
//    private var _dataStack: DataStack?
//    public var dataStack: DataStack? {
//        get {
//            if _dataStack == nil {
//                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle"),
//                    let bundle = Bundle(url: bundleURL),
//                    let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd"),
//                    let objectModel = NSManagedObjectModel(contentsOf: momURL) else {
//                    return nil
//                }
//                _dataStack = DataStack(model: objectModel, storeType: .sqLite)
//            }
//            return _dataStack
//        }
//        set {
//            _dataStack = newValue
//        }
//    }
    
    private var _realm: Realm?
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
    
    public let typeNames = ["Artifact",
                            "Chaos",
                            "Conspiracy",
                            "Creature",
                            "Enchantment",
                            "Instant",
                            "Land",
                            "Phenomenon",
                            "Plane",
                            "Planeswalker",
                            "Scheme",
                            "Sorcery",
                            "Tribal",
                            "Vanguard"]
    
    fileprivate var tcgPlayerPartnerKey: String?
    fileprivate var tcgPlayerPublicKey: String?
    fileprivate var tcgPlayerPrivateKey: String?
    
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

        if let scryfallDate = UserDefaults.standard.string(forKey: Constants.ScryfallDateKey) {
            if scryfallDate == Constants.ScryfallDate {
                willCopy = false
            }
        }

        if willCopy {
            print("Copying database file: \(Constants.ScryfallDate)")

            // Shutdown database
//            realm.close()
            
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
            
            UserDefaults.standard.set(Constants.ScryfallDate, forKey: Constants.ScryfallDateKey)
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
    
    // MARK: Database methods
    public func typeImage(ofCard card: CMCard) -> UIImage? {
        if let type = card.myType,
            let name = type.name {

            return ManaKit.sharedInstance.symbolImage(name: name)
        }
        
        return nil
    }
    
    public func typeText(ofCard card: CMCard, includePower: Bool) -> String {
        var typeText = ""
        
        if let language = card.language,
            let code = language.code {
            
            if code == "en" {
                if let type = card.typeLine,
                    let name = type.name {
                    typeText = name
                }
            } else {
                if let type = card.printedTypeLine,
                    let name = type.name {
                    typeText = name
                }
            }
            
            // fallback to default typeLine
            if typeText.count == 0 {
                if let type = card.typeLine,
                    let name = type.name {
                    typeText = name
                }
            }
            
            if includePower {
                if let power = card.power,
                    let toughness = card.toughness {
                    typeText.append(" (\(power)/\(toughness))")
                }
                
                if let loyalty = card.loyalty {
                    typeText.append(" (\(loyalty))")
                }
            }
        }
        
        return typeText
    }
    
    public func imageURL(ofCard card: CMCard, imageType: ImageType, faceOrder: Int) -> URL? {
        var url:URL?
        var urlString: String?
        
        
        if let imageURIs = card.imageURIs,
            let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
            urlString = dict[imageType.description]
        } else {
            let faces = card.faces
            let orderedFaces = faces.sorted(by: {(a, b) -> Bool in
                return a.faceOrder < b.faceOrder
            })
            let face = orderedFaces[faceOrder]
            
            if let imageURIs = face.imageURIs,
                let dict = NSKeyedUnarchiver.unarchiveObject(with: imageURIs as Data) as? [String: String] {
                urlString = dict[imageType.description]
            }
        }
        
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        
        return url
    }
    
    public func isModern(_ card: CMCard) -> Bool {
        guard let releaseDate = card.set!.releaseDate else {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let eightEditionDate = formatter.date(from: Constants.EightEditionRelease),
            let setReleaseDate = formatter.date(from: releaseDate) {
            return setReleaseDate.compare(eightEditionDate) == .orderedDescending ||
                setReleaseDate.compare(eightEditionDate) == .orderedSame
        }
        
        return false
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
    
    public func downloadImage(ofCard card: CMCard, imageType: ImageType, faceOrder: Int) -> Promise<Void> {
        guard let url = imageURL(ofCard: card,
                                 imageType: imageType,
                                 faceOrder: faceOrder) else {
            
            return Promise { seal  in
                let error = NSError(domain: NSURLErrorDomain,
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "No valid URL for image"])
                seal.reject(error)
            }
        }
        
        let roundCornered = imageType != .artCrop
        
        if let _ = self.cardImage(card,
                                  imageType: imageType,
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
    
    public func cardImage(_ card: CMCard, imageType: ImageType, faceOrder: Int, roundCornered: Bool) -> UIImage? {
        var cardImage: UIImage?
        
        guard let url = imageURL(ofCard: card,
                                 imageType: imageType,
                                 faceOrder: faceOrder) else {
            return nil
        }
        
        let imageCache = SDImageCache.init()
        let cacheKey = url.absoluteString
        
        cardImage = imageCache.imageFromDiskCache(forKey: cacheKey)
        
        if roundCornered {
            if let c = cardImage {
                cardImage = c.roundCornered(card: card)
            }
        }
        
        return cardImage
    }
    
    public func cardBack(_ card: CMCard) -> UIImage? {
        if card.set!.code == "ced" {
            return imageFromFramework(imageName: .collectorsCardBack)
        } else if card.set!.code == "cei" {
            return imageFromFramework(imageName: .intlCollectorsCardBack)
        } else {
            return imageFromFramework(imageName: .cardBack)
        }
    }
    
    // MARK: TCGPlayer
    public func configureTCGPlayer(partnerKey: String, publicKey: String?, privateKey: String?) {
        tcgPlayerPartnerKey = partnerKey
        tcgPlayerPublicKey = publicKey
        tcgPlayerPrivateKey = privateKey
    }
    
    public func fetchTCGPlayerCardPricing(card: CMCard) -> Promise<Void> {
        return Promise { seal  in
            if card.willUpdateTCGPlayerCardPricing() {
                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
                    let set = card.set,
                    let tcgPlayerSetName = set.tcgplayerName,
                    let cardName = card.name,
                    let urlString = "http://partner.tcgplayer.com/x3/phl.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\(tcgPlayerSetName)&p=\(cardName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
    
    public func fetchTCGPlayerStorePricing(card: CMCard) -> Promise<Void> {
        return Promise { seal  in
            if card.willUpdateTCGPlayerStorePricing() {
                guard let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
                    let set = card.set,
                    let tcgPlayerSetName = set.tcgplayerName,
                    let cardName = card.name,
                    let urlString = "http://partner.tcgplayer.com/x3/pv.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\(tcgPlayerSetName)&p=\(cardName)&v=8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
    
    // MARK: Keyrune
    public func keyruneUnicode(forSet set: CMSet) -> String? {
        var unicode:String?
        
        if let keyruneCode = set.myKeyruneCode {
            let charAsInt = Int(keyruneCode, radix: 16)!
            let uScalar = UnicodeScalar(charAsInt)!
            unicode = "\(uScalar)"
        } else {
            let charAsInt = Int("e684", radix: 16)!
            let uScalar = UnicodeScalar(charAsInt)!
            unicode = "\(uScalar)"
        }
        
        return unicode
    }
        
    public func keyruneColor(forCard card: CMCard) -> UIColor? {
        guard let set = card.set,
            let rarity = card.rarity else {
            return nil
        }
        
        var color:UIColor?
        
        if set.code == "tsb" {
            color = UIColor(hex: "652978") // purple
        } else {
            if rarity.name == "Common" {
                color = UIColor(hex: "1A1718")
            } else if rarity.name == "Uncommon" {
                color = UIColor(hex: "707883")
            } else if rarity.name == "Rare" {
                color = UIColor(hex: "A58E4A")
            } else if rarity.name == "Mythic" {
                color = UIColor(hex: "BF4427")
            } else if rarity.name == "Special" {
                color = UIColor(hex: "BF4427")
            } else if rarity.name == "Timeshifted" {
                color = UIColor(hex: "652978")
            } else if rarity.name == "Basic Land" {
                color = UIColor(hex: "000000")
            }
        }
        
        return color
    }
}
