//
//  Maintainer+Images.swift
//  ManaKit
//
//  Created by Vito Royeca on 1/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ManaKit
import PostgresClientKit
import PromiseKit
import SDWebImage

extension Maintainer {
    func fetchCardImages() -> Promise<Void> {
        return Promise { seal in
            let array = self.cardsData()
            var promises = [()->Promise<Void>]()
            var filteredData = [[String: Any]]()

            // -- Start Option 1 -- //
            for dict in array {
            // -- End Option 1 -- //
            
            // -- Start Option 2 -- //
//            for i in 0 ... array.count-1 {
//                if i < 50000 {
//                    continue
//                }
//                let dict = array[i]
            // -- End Option 2 -- //

                
                guard let number = dict["collector_number"] as? String,
                      let language = dict["lang"] as? String,
                      let set = dict["set"] as? String else {
                    continue
                }
                
                if let imageUrisDict = dict["image_uris"] as? [String: String] {
                    let imageUrisDict = createImageUris(number: number.replacingOccurrences(of: "★", with: "star"),
                                                        set: set,
                                                        language: language,
                                                        imageUrisDict: imageUrisDict)
                    filteredData.append(imageUrisDict)
                }
                
                if let faces = dict["card_faces"] as? [[String: Any]] {
                    for i in 0...faces.count-1 {
                        let face = faces[i]
                        
                        if let imageUrisDict = face["image_uris"] as? [String: String] {
                            let faceImageUrisDict = createImageUris(number: "\(number.replacingOccurrences(of: "★", with: "star"))_\(i)",
                                                                    set: set,
                                                                    language: language,
                                                                    imageUrisDict: imageUrisDict)
                            filteredData.append(faceImageUrisDict)
                        }
                    }
                }
            }
            
            promises.append(contentsOf: filteredData.map { dict in
                return {
                    return self.createImageDownloadPromise(dict: dict)
                }
            })
            
            let completion = {
                seal.fulfill(())
            }
            self.execInSequence(label: "fetchCardImages",
                                promises: promises,
                                completion: completion)
        }
    }
    
    func createImageUris(number: String, set: String, language: String, imageUrisDict: [String: String]) -> [String: Any] {
        var newDict = [String: Any]()
        
        // remove the key (?APIKEY) in the url
        var newImageUris = [String: String]()
        for (k,v) in imageUrisDict {
            newImageUris[k] = v.components(separatedBy: "?").first
        }
    
        newDict["number"] =  number
        newDict["language"] =  language
        newDict["set"] =  set
        newDict["imageUris"] =  newImageUris
        
        return newDict
    }

    func createImageDownloadPromise(dict: [String: Any]) -> Promise<Void> {
        return Promise { seal in
            guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                fatalError("Malformed cachePath")
            }
            guard let number = dict["number"] as? String,
                let language = dict["language"] as? String,
                let set = dict["set"] as? String,
                let imageUris = dict["imageUris"] as? [String: String] else {
                fatalError("Wrong download keys")
            }
            
            let imagesPath   = "\(cachePath)/card_images/\(set)/\(language)/\(number)"
            let downloadPath  = "\(cachePath)/card_downloads/\(set)/\(language)/\(number)"
            var promises = [Promise<Void>]()
            var remoteImageData: Data?
            
            for (k,v) in imageUris {
                var imageFile = "\(imagesPath)/\(k)"
                var downloadFile = "\(downloadPath)/\(k)"
                var willDownload = false
                
                if v.lowercased().hasSuffix("png") {
                    imageFile = "\(imageFile).png"
                    downloadFile = "\(downloadFile).png"
                } else if v.lowercased().hasSuffix("jpg") {
                    imageFile = "\(imageFile).jpg"
                    downloadFile = "\(downloadFile).jpg"
                }
                
                if FileManager.default.fileExists(atPath: imageFile) {
//                    do {
//                      // Compare local and remote files
//                      let localImageData = try Data(contentsOf: URL(fileURLWithPath: imageFile))
//                      remoteImageData = try Data(contentsOf: URL(string: v)!)
//                      willDownload = localImageData != remoteImageData
//                    } catch {
//                      print(error)
//                      willDownload = true
//                    }
                } else if FileManager.default.fileExists(atPath: downloadFile) {
//                    do {
//                      // Compare local and remote files
//                      let localImageData = try Data(contentsOf: URL(fileURLWithPath: downloadFile))
//                      remoteImageData = try Data(contentsOf: URL(string: v)!)
//                      willDownload = localImageData != remoteImageData
//                    } catch {
//                      print(error)
//                      willDownload = true
//                    }
                } else {
                    willDownload = true
                }
                
                if willDownload {
                    if k == "art_crop" || k == "normal" || k == "png" {
                        if let remoteImageData = remoteImageData {
                            promises.append(saveImagePromise(imageData: remoteImageData,
                                                             destinationFile: downloadFile))
                        } else {
                            promises.append(downloadImagePromise(url: v,
                                                                 destinationFile: downloadFile))
                        }
                    }
                }
            }

            if promises.isEmpty {
                seal.fulfill(())
            } else {
                firstly {
                    when(fulfilled: promises)
                }.done {
                    seal.fulfill(())
                }.catch { error in
                    print(error)
                    seal.fulfill(())
                }
            }
        }
    }
    
    func saveImagePromise(imageData: Data, destinationFile: String) -> Promise<Void> {
        return Promise { seal in
            do {
                prepare(destinationFile: destinationFile)
                try imageData.write(to: URL(fileURLWithPath: destinationFile))
                seal.fulfill(())
            } catch {
                let error = NSError(domain: NSURLErrorDomain,
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Unable to write to: \(destinationFile)"])
                seal.reject(error)
            }
        }
    }
    
    func downloadImagePromise(url: String, destinationFile: String) -> Promise<Void> {
        return Promise { seal in
            let completion = { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
                if let error = error {
                    seal.reject(error)
                } else {
                    if let data = data {
                        do {
                            self.prepare(destinationFile: destinationFile)
                            try data.write(to: URL(fileURLWithPath: destinationFile))
                            print("Downloaded \(url)")
                            seal.fulfill(())
                        } catch {
                            let error = NSError(domain: NSURLErrorDomain,
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "Unable to write to: \(destinationFile)"])
                            seal.reject(error)
                        }
                    } else {
                        let error = NSError(domain: NSURLErrorDomain,
                                            code: 404,
                                            userInfo: [NSLocalizedDescriptionKey: "Data not found: \(url)"])
                        seal.reject(error)
                    }
                }
            }
            SDWebImageDownloader.shared.downloadImage(with: URL(string: url),
                                                      options: .lowPriority,
                                                      progress: nil,
                                                      completed: completion)
        }
    }
    
    func copyImagePromise(sourceFile: String, destinationFile: String) -> Promise<Void> {
        return Promise { seal in
            do {
                prepare(destinationFile: destinationFile)
                try FileManager.default.copyItem(at: URL(fileURLWithPath: sourceFile),
                                                 to: URL(fileURLWithPath: destinationFile))
                seal.fulfill(())
            } catch {
                let error = NSError(domain: NSURLErrorDomain,
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Unable to write to: \(destinationFile)"])
                seal.reject(error)
            }
        }
    }
    
    private func prepare(destinationFile: String) {
        do {
            let destinationURL = URL(fileURLWithPath: destinationFile)
            let parentDir = destinationURL.deletingLastPathComponent().path
            
            // create parent dirs
            if !FileManager.default.fileExists(atPath: parentDir) {
                try! FileManager.default.createDirectory(atPath: parentDir,
                                                         withIntermediateDirectories: true,
                                                         attributes: nil)
            }
            
            // delete if existing
            if FileManager.default.fileExists(atPath: destinationFile) {
                try FileManager.default.removeItem(atPath: destinationFile)
            }
        } catch {
            print(error)
        }
    }
}
