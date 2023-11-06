//
//  ManaKit+Async.swift
//
//
//  Created by Vito Royeca on 11/5/23.
//

import Foundation

extension ManaKit {
    func fetchData<T: MEntity>(_ entity: T.Type,
                               url: URL) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            fetchData(entity, url: url) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func delete<T: MGEntity>(_ entity: T.Type,
                             predicate: NSPredicate) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            delete(entity, predicate: predicate) { result in
                continuation.resume(with: result)
            }
        }
    }

    public func fetchSet(code: String,
                         languageCode: String) async throws -> MGSet? {
        return try await withCheckedThrowingContinuation { continuation in
            fetchSet(code: code, languageCode: languageCode) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    public func fetchSets() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            fetchSets() { result in
                continuation.resume(with: result)
            }
        }
    }

    public func fetchCard(newID: String) async throws -> MGCard? {
        return try await withCheckedThrowingContinuation { continuation in
            fetchCard(newID: newID) { result in
                continuation.resume(with: result)
            }
        }
    }

    public func fetchCards(query: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            fetchCards(query: query) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    public func fetchCardOtherPrintings(newID: String, languageCode: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            fetchCardOtherPrintings(newID: newID, languageCode: languageCode) { result in
                continuation.resume(with: result)
            }
        }
    }
}
