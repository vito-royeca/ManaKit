//
//  ManaKit+SwiftData.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import Foundation
import SwiftData

// MARK: - Base class

public protocol SDEntity: PersistentModel, Identifiable {
    //    convenience init(from entity: MEntity) {
    //        self.init(context: context)
    //    }
    func update<T>(keyPath: ReferenceWritableKeyPath<any SDEntity, T>, to value: T)
//    static func fetchDescriptor(with primaryKey: Any) -> FetchDescriptor<Self>
}

extension SDEntity {
    public func update<T>(keyPath: ReferenceWritableKeyPath<any SDEntity, T>, to value: T) {
        self[keyPath: keyPath] = value
//        lastModified = .now
    }
}

extension ManaKit {
    public func find<T: SDEntity>(_ entity: T.Type,
                                  properties: [String: Any]?,
                                  predicate: Predicate<T>?,
                                  sortDescriptors: [SortDescriptor<T>]?,
                                  createIfNotFound: Bool,
//                                  fetchDescriptor: FetchDescriptor<T>,
                                  context: ModelContext) -> [T]? {
        
        var request = FetchDescriptor<T>()
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            request.sortBy = sortDescriptors
        }

        do {
            let objects = try context.fetch(request)
            
            if !objects.isEmpty {
                objects.forEach {
                    for (key,value) in properties ?? [:] {
                        update(entity: $0, entityType: entity, property: key, value: value)
                    }
                }
                try context.save()
                return objects

            } else {
                if createIfNotFound {
                    if let object = create(entityType: entity, context: context) {
                        for (key,value) in properties ?? [:] {
                            update(entity: object, entityType: entity, property: key, value: value)
                        }
                    }
                    
                    try context.save()
                    
                    return find(entity,
                                properties: properties,
                                predicate: predicate,
                                sortDescriptors: sortDescriptors,
                                createIfNotFound: createIfNotFound,
//                                fetchDescriptor: fetchDescriptor,
                                context: context)
                } else {
                    return nil
                }
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func delete<T: SDEntity>(_ entity: T.Type,
                             predicate: Predicate<T>) throws {

        try sdBackgroundContext.delete(model: entity,
                                      where: predicate)
    }

    func save(context: ModelContext) {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func keyPath<T: SDEntity, U: Any>(_ entity: T.Type, for name: String, type: U.Type) -> KeyPath<T, U>? {
        for meta in entity.schemaMetadata {
            let mirror = Mirror(reflecting: meta)
            var nameValue: String?
            var keyPath: KeyPath<T, U>?
            
            for case let (label?, value) in mirror.children {
                if label == "name" {
                    nameValue = value as? String
                } else if label == "keypath" {
                    keyPath = value as? KeyPath<T, U>
                }
            }
            
            if nameValue == name {
                return keyPath
            }
        }
        
        return nil
    }
    
    func update<T: SDEntity>(entity: T, entityType: T.Type, property: String, value: Any) {
        if let value = value as? Bool,
           let keyPath = keyPath(entityType, for: property, type: Bool.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? Date,
           let keyPath = keyPath(entityType, for: property, type: Date.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? Double,
           let keyPath = keyPath(entityType, for: property, type: Double.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? Int,
           let keyPath = keyPath(entityType, for: property, type: Int.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? Int32,
           let keyPath = keyPath(entityType, for: property, type: Int32.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? Int64,
           let keyPath = keyPath(entityType, for: property, type: Int64.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        } else if let value = value as? String,
           let keyPath = keyPath(entityType, for: property, type: String.self) {
           let oldValue = entity.getValue(forKey: keyPath)
            if "\(oldValue)" != "\(value)" {
                entity.setValue(forKey: keyPath, to: value)
            }
        }
    }
    
    func create<T: SDEntity>(entityType: T.Type, context: ModelContext) -> T? {
        if entityType == SDArtist.self {
            let entity = SDArtist(name: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDCard.self {
            let entity = SDCard(newID: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDLanguage.self {
            let entity = SDLanguage(code: "",
                                    name: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDLocalCache.self {
            let entity = SDLocalCache(lastUpdated: nil,
                                      url: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDSet.self {
            let entity = SDSet(code: "",
                               name: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDSetBlock.self {
            let entity = SDSetBlock(code: "",
                                    name: "")
            context.insert(entity)
            return entity as? T
        } else if entityType == SDSetType.self {
            let entity = SDSetType(name: "")
            context.insert(entity)
            return entity as? T
        } else {
            return nil
        }
    }
}
