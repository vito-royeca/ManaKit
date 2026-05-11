//
//  ManaKitUtilities+Data.swift
//  ManaKit
//
//  Created by Vito Royeca on 4/20/26.
//

import Foundation

public enum SectionedSetsType: String {
    case byName = "sets_by_name"
    case byType = "sets_by_type"
    case byYear = "sets_by_year"
}

extension ManaKitUtilities {
    public func setsByYear() async throws -> SectionedSets? {
        do {
            guard let path = Bundle.module.path(forResource: "set_by_year", ofType: "json") else {
                return nil
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
               let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                let queryData = try await SetsByYearQuery.Data(data: jsonValue)
                let results = queryData.setsByYear?.fragments.sectionedSets
                return results
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }

    public func set(setID: String, languageID: String) async throws -> SetQuery.Data.Set? {
        do {
            guard let path = Bundle.module.path(forResource: "set_\(setID)_\(languageID)", ofType: "json") else {
                return nil
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
               let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                let queryData = try await SetQuery.Data(data: jsonValue)
                let results = queryData.set
                return results
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    public func sets(type: SectionedSetsType) async throws -> SectionedSets? {
        do {
            guard let path = Bundle.module.path(forResource: type.rawValue, ofType: "json") else {
                return nil
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
               let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                let queryData = try await SetsByNameQuery.Data(data: jsonValue)
                let results = queryData.setsByName?.fragments.sectionedSets
                return results
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    public func card(id: String) async throws -> CardCompleteInfo? {
        do {
            guard let path = Bundle.module.path(forResource: "card_\(id)", ofType: "json") else {
                return nil
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyHashable],
               let jsonValue = jsonObject["data"] as? [String: AnyHashable] {
                let queryData = try await CardQuery.Data(data: jsonValue)
                let results = queryData.card?.fragments.cardCompleteInfo
                return results
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}
