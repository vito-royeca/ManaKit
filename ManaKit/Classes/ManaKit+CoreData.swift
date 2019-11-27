//
//  ManaKit+CoreData.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import SDWebImage
import SSZipArchive
import Sync

extension ManaKit {
    public func needsUpgrade() -> Bool {
        var willUpgrade = true
        
        if let scryfallDate = UserDefaults.standard.string(forKey: UserDefaultsKeys.ScryfallDate) {
            if scryfallDate == Constants.ScryfallDate {
                willUpgrade = false
            }
        }
        
        return willUpgrade
    }
    
    func copyDatabaseFile() {
            let bundle = Bundle(for: ManaKit.self)
            guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
                let resourceBundle = Bundle(url: bundleURL),
                let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
                let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
                let sourcePath = resourceBundle.path(forResource: "ManaKit.sqlite", ofType: "zip"),
                let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
                return
            }
            let targetPath = "\(docsPath)/\(bundleName).sqlite"

            if needsUpgrade() {
                print("Copying database file: \(Constants.ScryfallDate)")
                
                // Shutdown database
                dataStack = nil

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
                try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.sqlite", toPath: targetPath)
                
                // skip from iCloud backups!
                var targetURL = URL(fileURLWithPath: targetPath)
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try! targetURL.setResourceValues(resourceValues)
                
                UserDefaults.standard.set(Constants.ScryfallDate, forKey: UserDefaultsKeys.ScryfallDate)
                UserDefaults.standard.synchronize()
            }
        }
    
}
