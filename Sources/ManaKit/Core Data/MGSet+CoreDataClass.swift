//
//  MGSet+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGSet: MGEntity {
    public var sortedLanguageCodes: [String]? {
        guard let set = languages,
            let array = set.allObjects as? [MGLanguage] else {
            return nil
        }

        let arrayMap = array.map { $0.code }
        var sortedArray = [String]()
        
        if arrayMap.contains("en") {
            sortedArray.append("EN")
        }
        if arrayMap.contains("es") {
            sortedArray.append("ES")
        }
        if arrayMap.contains("fr") {
            sortedArray.append("FR")
        }
        if arrayMap.contains("de") {
            sortedArray.append("DE")
        }
        if arrayMap.contains("it") {
            sortedArray.append("IT")
        }
        if arrayMap.contains("pt") {
            sortedArray.append("PT")
        }
        if arrayMap.contains("ja") {
            sortedArray.append("JA")
        }
        if arrayMap.contains("ko") {
            sortedArray.append("KO")
        }
        if arrayMap.contains("ru") {
            sortedArray.append("RU")
        }
        if arrayMap.contains("zhs") {
            sortedArray.append("汉语")
        }
        if arrayMap.contains("zht") {
            sortedArray.append("漢語")
        }
        
        return sortedArray
    }
}
