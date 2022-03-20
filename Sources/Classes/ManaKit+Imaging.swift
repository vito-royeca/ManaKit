//
//  ManaKit+Imaging.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import UIKit

extension ManaKit {
    public func image(name: ImageName) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL) else {
            return nil
        }

        return UIImage(named: name.rawValue, in: resourceBundle, compatibleWith: nil)
    }

    public func symbolImage(name: String) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)

        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("ManaKit.bundle"),
            let resourceBundle = Bundle(url: bundleURL) else {
            return nil
        }

        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
    
//    public func downloadImage(ofCard card: MGCard, type: CardImageType, faceOrder: Int) -> Promise<Void> {
//        guard let url = card.imageURL(type: type,
//                                      faceOrder: faceOrder) else {
//            
//            return Promise { seal  in
//                let error = NSError(domain: NSURLErrorDomain,
//                                    code: 404,
//                                    userInfo: [NSLocalizedDescriptionKey: "No valid URL for image"])
//                seal.reject(error)
//            }
//        }
//        
//        let roundCornered = type != .artCrop
//        
//        if let _ = card.image(type: type,
//                              faceOrder: faceOrder,
//                              roundCornered: roundCornered) {
//            return Promise { seal  in
//                seal.fulfill(())
//            }
//        } else {
//            return downloadImage(url: url)
//        }
//    }
    
//    public func downloadImage(url: URL) -> Promise<Void> {
//        return Promise { seal in
//            let cacheKey = url.absoluteString
//            let completion = { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
//                if let error = error {
//                    seal.reject(error)
//                } else {
//                    if let image = image {
//                        let imageCache = SDImageCache.init()
//                        let imageCacheCompletion = {
//                            seal.fulfill(())
//                        }
//
//                        imageCache.store(image,
//                                         forKey: cacheKey,
//                                         toDisk: true,
//                                         completion: imageCacheCompletion)
//
//                    } else {
//                        let error = NSError(domain: NSURLErrorDomain,
//                                            code: 404,
//                                            userInfo: [NSLocalizedDescriptionKey: "Image not found: \(url)"])
//                        seal.reject(error)
//                    }
//                }
//            }
//
//            SDWebImageDownloader.shared.downloadImage(with: url,
//                                                      options: .lowPriority,
//                                                      progress: nil,
//                                                      completed: completion)
//        }
//    }
}
