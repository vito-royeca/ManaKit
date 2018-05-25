//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import DATASource
import Kanna
import PromiseKit
import SDWebImage
import SSZipArchive
import Sync


public let kMTGJSONVersion      = "3.15.2 J"
public let kMTGJSONDate         = "Apr 20, 2018"
public let kMTGJSONVersionKey   = "kMTGJSONVersionKey"
public let kImagesVersionKey    = "kImagesVersionKey"
public let kCardImageSource     = "http://magiccards.info/scans/en"
public let kEightEditionRelease = "2003-07-28"
public let kBasicRulesFile      = "2003-07-28"

public let kTCGPlayerPricingAge = 24*3 // 3 days

// Notification events
public let kNotificationCardImageDownloaded = "kNotificationCardImageDownloaded"

public enum ImageName: String {
    case cardCircles       = "images/Card_Circles",
    cardBackCropped        = "images/cardback-crop-hq",
    cardBack               = "images/cardback-hq",
    collectorsCardBack     = "images/collectorscardback-hq",
    cropBack               = "images/cropback-hq",
    grayPatterned          = "images/Gray_Patterned_BG",
    intlCollectorsCardBack = "images/internationalcollectorscardback-hq"
}

public let Symbols = [
    "∞": "{∞}",
    "0": "{0}",
    "1": "{1}",
    "2": "{2}",
    "3": "{3}",
    "4": "{4}",
    "5": "{5}",
    "6": "{6}",
    "7": "{7}",
    "8": "{8}",
    "9": "{9}",
    "10": "{10}",
    "11": "{11}",
    "12": "{12}",
    "13": "{13}",
    "14": "{14}",
    "15": "{15}",
    "16": "{16}",
    "17": "{17}",
    "18": "{18}",
    "19": "{19}",
    "20": "{20}",
    "100": "{100}",
    "1000000": "{1000000}",
    "B": "{B}",
    "BG": "{B/G}",
    "BP": "{B/P}",
    "BR": "{B/R}",
    "C": "{C}",
    "G": "{G}",
    "GP": "{G/P}",
    "GU": "{G/U}",
    "GW": "{G/W}",
    "R": "{R}",
    "RG": "{R/G}",
    "RP": "{R/P}",
    "RW": "{R/W}",
    "S": "{S}",
    "U": "{U}",
    "UB": "{U/B}",
    "UP": "{U/P}",
    "UR": "{U/R}",
    "W": "{W}",
    "WB": "{W/B}",
    "WP": "{W/P}",
    "WU": "{W/U}",
    "X": "{X}",
    "Y": "{Y}",
    "Z": "{Z}",
    "E": "{E}",
    "Q": "{Q}",
    "T": "{T}"
]

@objc(ManaKit)
open class ManaKit: NSObject {
    // MARK: - Shared Instance
    open static let sharedInstance = ManaKit()
    
    // MARK: Variables
    fileprivate var _dataStack:DataStack?
    open var dataStack:DataStack? {
        get {
            if _dataStack == nil {
                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle") else { return nil }
                guard let bundle = Bundle(url: bundleURL) else { return nil }
                guard let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd") else { return nil }
                guard let objectModel = NSManagedObjectModel(contentsOf: momURL) else { return nil }
                _dataStack = DataStack(model: objectModel, storeType: .sqLite)
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }
    
    fileprivate var tcgPlayerPartnerKey: String?
    fileprivate var tcgPlayerPublicKey: String?
    fileprivate var tcgPlayerPrivateKey: String?
    
    // MARK: Resource methods
    /*
     * Example path: "/images/set/2ED/C/48.png"
     */
    open func imageFromFramework(imageName: ImageName) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            return UIImage(named: imageName.rawValue, in: resourceBundle, compatibleWith: nil)
        }
        
        return nil
    }
    
    open func setImage(set: CMSet, rarity: CMRarity?) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        var prefix = "C"
        
        if let rarity = rarity {
            prefix = String(rarity.name!.prefix(1))
            
            if rarity.name == "Basic Land" {
                prefix = "C"
            }
        }

        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            var image = UIImage(named: "\(set.code!)-\(prefix)", in: resourceBundle, compatibleWith: nil)
            
            if image == nil {
                image = UIImage(named: "DEFAULT-\(prefix)", in: resourceBundle, compatibleWith: nil)
            }

            return image
        }
        
        return nil
    }
    
    open func manaImages(manaCost: String) -> [[String:UIImage]] {
        let bundle = Bundle(for: ManaKit.self)
        
        var array = [[String:UIImage]]()
        let mc = manaCost.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: " ")
            .replacingOccurrences(of: "/", with: "")
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            let manaArray = mc.components(separatedBy: " ")

            for mana in manaArray {
                if mana.count == 0 {
                    continue
                }
                
                var image = UIImage(named: "\(mana)", in: resourceBundle, compatibleWith: nil)
                
                // fix for dual manas
                if image == nil {
                    if mana.count > 1 {
                        let reversedMana = String(mana.reversed())

                        image = UIImage(named: "\(reversedMana)", in: resourceBundle, compatibleWith: nil)
                    }
                }
                
                if let image = image {
                    array.append([mana:image])
                }
            }
        }
        
        return array
    }
    
    open func symbolImage(name: String) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            
            return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
        }
        
        return nil
    }
    
    open func symbolHTML(name: String) -> String? {
        let cleanName = name.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .replacingOccurrences(of: "/", with: "")
        var image: UIImage?
        var html: String?
        
        if name.contains("E") ||
            name.contains("Q") ||
            name.contains("T") {
            image = symbolImage(name: cleanName)
        } else {
            for array in manaImages(manaCost: name) {
                for (_,value) in array {
                    image = value
                }
            }
        }
        
        if let image = image {
            if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
                let targetDir = "\(cachePath)/symbols"
                let targetPath = "\(targetDir)/\(cleanName).png"
                
                if !FileManager.default.fileExists(atPath: targetPath) {
                    // create targetDir
                    if !FileManager.default.fileExists(atPath: targetDir) {
                        try! FileManager.default.createDirectory(atPath: targetDir, withIntermediateDirectories: true, attributes: nil)
                    }
                
                    try! UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: targetPath))
                }
                var width = "25"
                if cleanName == "100" {
                    width = "50"
                } else if cleanName == "1000000" {
                    width = "75"
                }
                
                html = "<img src='\(targetPath)' width='\(width)' height='25' />"
            }
        }
        
        return html
    }
    
    open func nibFromBundle(_ name: String) -> UINib? {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            
            return UINib(nibName: name, bundle: resourceBundle)
        }
        
        return nil
    }
    
    open func basicRulesPath() -> String? {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            return resourceBundle?.path(forResource: "EN_M15_QckStrtBklt_LR_Crop", ofType: "pdf")
        }
        
        return nil
    }
    
    open func setupResources() {
        // unpack the image symbols
        for (_,v) in Symbols {
            let _ = ManaKit.sharedInstance.symbolHTML(name: v)
        }
        
        copyDatabaseFile()
        loadCustomFonts()
    }
    
    func copyDatabaseFile() {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            
            if let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
                let sourcePath = resourceBundle?.path(forResource: "ManaKit.sqlite", ofType: "zip"),
                let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
                
                var willCopy = true

                // Check if we have old files
                let targetPath = "\(docsPath)/\(bundleName).sqlite"
                willCopy = !FileManager.default.fileExists(atPath: targetPath)
                
                // Check if we saved the version number
                if let version = databaseVersion() /*UserDefaults.standard.object(forKey: kMTGJSONVersionKey) as? String*/ {
                    willCopy = version != kMTGJSONVersion
                } else {
                    willCopy = true
                }
                
                if willCopy {
                    // Shutdown database
                    dataStack = nil
                    
                    // Remove old database files
                    for file in try! FileManager.default.contentsOfDirectory(atPath: docsPath) {
                        let path = "\(docsPath)/\(file)"
                        if file.hasPrefix(bundleName) {
                            try! FileManager.default.removeItem(atPath: path)
                        }
                    }
                    
                    // Unzip
                    SSZipArchive.unzipFile(atPath: sourcePath, toDestination: docsPath)
                    
                    // rename
                    try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.sqlite", toPath: targetPath)
                    
                    // skip from iCloud backups!
                    var targetURL = URL(fileURLWithPath: targetPath)
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    try! targetURL.setResourceValues(resourceValues)
                    
                    // Save the version
                    UserDefaults.standard.set(kMTGJSONVersion, forKey: kMTGJSONVersionKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    func loadCustomFonts() {
        let bundle = Bundle(for: ManaKit.self)
        
        if let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle") {
            let resourceBundle = Bundle(url: bundleURL)
            
            if let urls = resourceBundle?.urls(forResourcesWithExtension: "ttf", subdirectory: "fonts") {
                for url in urls {
                    let data = try! Data(contentsOf: url)
                    let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil

                    if let provider = CGDataProvider(data: data as CFData) {
                        let font = CGFont(provider)
                        
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
        }
    }
    
    // MARK: Database methods
    open func findOrCreateObject(_ entityName: String, objectFinder: [String: AnyObject]?) -> NSManagedObject? {
        var object:NSManagedObject?
        var predicate:NSPredicate?
        var fetchRequest:NSFetchRequest<NSFetchRequestResult>?
        
        if let objectFinder = objectFinder {
            for (key,value) in objectFinder {
                if predicate != nil {
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, NSPredicate(format: "%K == %@", key, value as! NSObject)])
                } else {
                    predicate = NSPredicate(format: "%K == %@", key, value as! NSObject)
                }
            }

            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest!.predicate = predicate
        }
        
        if let fetchRequest = fetchRequest {
            if let m = try! dataStack?.mainContext.fetch(fetchRequest).first as? NSManagedObject {
                object = m
            } else {
                if let desc = NSEntityDescription.entity(forEntityName: entityName, in: dataStack!.mainContext) {
                    object = NSManagedObject(entity: desc, insertInto: dataStack?.mainContext)
                    try! dataStack?.mainContext.save()
                }
            }
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: entityName, in: dataStack!.mainContext) {
                object = NSManagedObject(entity: desc, insertInto: dataStack?.mainContext)
                try! dataStack?.mainContext.save()
            }
        }
        
        return object
    }
    
    open func databaseVersion() -> String? {
        var version:String?
        
        let objectFinder = ["version": kMTGJSONVersion] as [String: AnyObject]
        if let object = ManaKit.sharedInstance.findOrCreateObject("CMSystem", objectFinder: objectFinder) as? CMSystem {
            version = object.version
        }
        
        return version
    }
    
    // MARK: Miscellaneous methods
    open func imageURL(ofCard card: CMCard) -> URL? {
        var url:URL?
        
        if card.multiverseid == 0 {
            if let set = card.set {
                if let code = set.magicCardsInfoCode ?? set.code,
                    let number = card.number ?? card.mciNumber {
                    let path = "\(kCardImageSource)/\(code.lowercased())/\(number).jpg"
                    url = URL(string: path)
                }
            }

        } else {
            let path = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=\(card.multiverseid)&type=card"
            url = URL(string: path)
        }
        
        return url
    }
    
    open func downloadCardImage(_ card: CMCard, cropImage: Bool, completion: @escaping (_ card: CMCard, _ image: UIImage?, _ croppedImage: UIImage?, _ error: Error?) -> Void) {
        
        if let url = imageURL(ofCard: card) {
            if let image = self.cardImage(card) {
                completion(card, image, cropImage ? self.crop(image, ofCard: card) : nil, nil)
            } else {
                let downloader = SDWebImageDownloader.shared()
                let cacheKey = url.absoluteString
                let completion = { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
                    if let image = image {
                        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
                        let imageCache = SDImageCache.init(namespace: appName)
                        imageCache.store(image, forKey: cacheKey, toDisk: true, completion: nil)
                        completion(card, image, cropImage ? self.crop(image, ofCard: card) : nil, nil)
                    } else {
                        completion(card, nil, nil, error)
                    }
                }
                
                downloader.downloadImage(with: url, options: .lowPriority, progress: nil, completed: completion)
            }
        }
    }
    
    open func isModern(_ card: CMCard) -> Bool {
        var isModern = false
        
        if let releaseDate = card.set!.releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let eightEditionDate = formatter.date(from: kEightEditionRelease),
                let setReleaseDate = formatter.date(from: releaseDate) {
                isModern = setReleaseDate.compare(eightEditionDate) == .orderedDescending ||
                           setReleaseDate.compare(eightEditionDate) == .orderedSame
            }
        }
        
        return isModern
    }
    
    open func crop(_ image: UIImage, ofCard card: CMCard) -> UIImage? {
        if let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let path = "\(dir)/crop/\(card.set!.code!)"
            
            if let number = card.number ?? card.mciNumber {
                let cropPath = "\(path)/\(number)-crop.jpg"
                
                if FileManager.default.fileExists(atPath: cropPath) {
                    return UIImage(contentsOfFile: cropPath)
                } else {
                    let width = image.size.width * 3/4
                    let rect = CGRect(x: (image.size.width-width) / 2,
                                      y: isModern(card) ? 47 : 40,
                                      width: width,
                                      height: width-60)
                    
                    let imageRef = image.cgImage!.cropping(to: rect)
                    let croppedImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
                    
                    
                    // write to file
                    if !FileManager.default.fileExists(atPath: path)  {
                        try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    }
                    try! UIImageJPEGRepresentation(croppedImage, 1.0)?.write(to: URL(fileURLWithPath: cropPath))
                    
                    return UIImage(contentsOfFile: cropPath)
                }
            }
        }
        
        return nil
    }
    
    open func cardImage(_ card: CMCard) -> UIImage? {
        var cardImage: UIImage?
        
        if let url = imageURL(ofCard: card) {
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
            let imageCache = SDImageCache.init(namespace: appName)
            let cacheKey = url.absoluteString
            
            let semaphore = DispatchSemaphore(value: 0)
            let cacheQueryCompletion = { (image: UIImage?, data: Data?, cacheType: SDImageCacheType) in
                cardImage = image
                semaphore.signal()
            }
            
            imageCache.queryCacheOperation(forKey: cacheKey, options: .queryDiskSync, done: cacheQueryCompletion)
            semaphore.wait()
        }
        
        if cardImage == nil {
            // delete crop if existing
        }
        return cardImage
    }
    
    open func cardBack(_ card: CMCard) -> UIImage? {
        if card.set!.code == "CED" {
            return imageFromFramework(imageName: .collectorsCardBack)
        } else if card.set!.code == "CEI" {
            return imageFromFramework(imageName: .intlCollectorsCardBack)
        } else {
            return imageFromFramework(imageName: .cardBack)
        }
    }
    
    open func croppedImage(_ card: CMCard) -> UIImage? {
        if let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let path = "\(dir)/crop/\(card.set!.code!)"
            
            if let number = card.number ?? card.mciNumber {
                let cropPath = "\(path)/\(number)-crop.jpg"
                
                if FileManager.default.fileExists(atPath: cropPath) {
                    return UIImage(contentsOfFile: cropPath)
                }
            }
        }
        
        return nil
    }
    
    // MARK: TCGPlayer
    open func configureTCGPlayer(partnerKey: String, publicKey: String?, privateKey: String?) {
        tcgPlayerPartnerKey = partnerKey
        tcgPlayerPublicKey = publicKey
        tcgPlayerPrivateKey = privateKey
    }
    
    open func fetchTCGPlayerPricing(card: CMCard, completion: @escaping (_ cardPricing: CMCardPricing?, _ error: Error?) -> Void) {
        if let pricing = findOrCreateObject("CMCardPricing", objectFinder: ["card.id": card.id as AnyObject]) as? CMCardPricing {
            var willFetch = false
            
            if let lastUpdate = pricing.lastUpdate {
                if let diff = Calendar.current.dateComponents([.hour], from: lastUpdate as Date, to: Date()).hour, diff >= kTCGPlayerPricingAge {
                    willFetch = true
                }
            } else {
                willFetch = true
            }
            
            if willFetch {
                if let tcgPlayerPartnerKey = tcgPlayerPartnerKey,
                    let tcgPlayerSetName = card.set?.tcgPlayerName,
                    let cardName = card.name {
                    
                    if let urlString = "http://partner.tcgplayer.com/x3/phl.asmx/p?pk=\(tcgPlayerPartnerKey)&s=\(tcgPlayerSetName)&p=\(cardName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        
                        if let url = URL(string: urlString) {
                            var rq = URLRequest(url: url)
                            rq.httpMethod = "GET"
//                            rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                            rq.addValue("application/json", forHTTPHeaderField: "Accept")
                            
                            firstly {
                                URLSession.shared.dataTask(.promise, with: rq)
                            }
                            .compactMap {
                                let xml = try! XML(xml: $0.data, encoding: .utf8)

                                for product in xml.xpath("//product") {
                                    if let id = product.xpath("id").first?.text,
                                        let hiprice = product.xpath("hiprice").first?.text,
                                        let lowprice = product.xpath("lowprice").first?.text,
                                        let avgprice = product.xpath("avgprice").first?.text,
                                        let foilavgprice = product.xpath("foilavgprice").first?.text,
                                        let link = product.xpath("link").first?.text {
                                        pricing.id = Int64(id)!
                                        pricing.high = Double(hiprice)!
                                        pricing.low = Double(lowprice)!
                                        pricing.average = Double(avgprice)!
                                        pricing.foil = Double(foilavgprice)!
                                        pricing.link = link
                                    }
                                }
                            }
                            .done { json in
                                    pricing.lastUpdate = NSDate()
                                    pricing.card = card
                                    try! self.dataStack?.mainContext.save()
                                    completion(pricing, nil)
                                    
                            }
                            .catch { error in
                                    completion(nil, error)
                            }
                        }
                        
                    }
                }
            } else {
                completion(pricing, nil)
            }
        } else {
            completion(nil, nil)
        }
    }
    
    // MARK: Keyrune
    open func keyruneUnicode(forSet set: CMSet) -> String? {
        var unicode:String?
        
        if let keyruneCode = set.keyruneCode {
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
        
    open func keyruneColor(forRarity rarity: CMRarity) -> UIColor? {
        var color:UIColor?
        
        if rarity.name == "Common" {
            color = hexStringToUIColor(hex: "1A1718")
        } else if rarity.name == "Uncommon" {
            color = hexStringToUIColor(hex: "707883")
        } else if rarity.name == "Rare" {
            color = hexStringToUIColor(hex: "A58E4A")
        } else if rarity.name == "Mythic Rare" {
            color = hexStringToUIColor(hex: "BF4427")
        } else if rarity.name == "Special" {
            color = hexStringToUIColor(hex: "BF4427")
        } else if rarity.name == "Timeshifted" {
            color = hexStringToUIColor(hex: "652978")
        } else if rarity.name == "Basic Land" {
            color = hexStringToUIColor(hex: "000000")
        }
        
        return color
    }
        
    open func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
