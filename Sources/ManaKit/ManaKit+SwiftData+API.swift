//
//  ManaKit+SwiftData+API.swift
//
//
//  Created by Vito Royeca on 2/15/24.
//

import Foundation
import SwiftData

extension ManaKit {
    public func fetchSet(code: String,
                         languageCode: String) async throws -> SDSet? {
        let url = try fetchSetURL(code: code,
                                  languageCode: languageCode)
        let predicate = #Predicate<SDSet> {
            $0.code == code
        }
        
        return try await fetchData(url: url,
                                   jsonType: MSet.self,
                                   swiftDataType: SDSet.self,
                                   predicate: predicate,
                                   sortDescriptors: nil).first
    }

    func fetchData<T: MEntity, U: SDEntity>(url: URL,
                                            jsonType: T.Type,
                                            swiftDataType: U.Type,
                                            predicate: Predicate<U>?,
                                            sortDescriptors: [SortDescriptor<U>]?) async throws -> [U] {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ManaKitError.invalidHttpResponse
            }

            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([T].self, from: data)
            let entities = syncToSwiftData(jsonData,
                                           jsonType: jsonType,
                                           swiftDataType: swiftDataType,
                                           sortDescriptors: sortDescriptors)
            saveCache(forUrl: url)
            return entities ?? []
        } catch {
            deleteCache(forUrl: url)
            throw error
        }
    }
}
