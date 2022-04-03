//
//  MGSet+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGSet: MGEntity {
    public var sortedLanguages: [MGLanguage]? {
        guard let set = languages,
            let array = set.allObjects as? [MGLanguage] else {
            return nil
        }

        let arrayMap = array.map { $0.code }
        var sortedArray = [MGLanguage]()
        
        if arrayMap.contains("en") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "en"}))
        }
        if arrayMap.contains("es") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "es"}))
        }
        if arrayMap.contains("fr") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "fr"}))
        }
        if arrayMap.contains("de") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "de"}))
        }
        if arrayMap.contains("it") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "it"}))
        }
        if arrayMap.contains("pt") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "pt"}))
        }
        if arrayMap.contains("ja") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "ja"}))
        }
        if arrayMap.contains("ko") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "ko"}))
        }
        if arrayMap.contains("ru") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "ru"}))
        }
        if arrayMap.contains("zhs") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "zhs"}))
        }
        if arrayMap.contains("zht") {
            sortedArray.append(contentsOf: array.filter({ $0.code == "zht"}))
        }
        
        return sortedArray
    }
    
    public var logoURL: URL? {
        guard let logoCode = logoCode,
            let url = URL(string: "\(ManaKit.shared.apiURL)/images/sets/\(logoCode).png") else {
            return nil
        }
        
        return url
    }
}
