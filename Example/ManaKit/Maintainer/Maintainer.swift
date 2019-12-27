//
//  Maintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ManaKit
import PostgresClientKit
import PromiseKit
import SSZipArchive

class Maintainer: NSObject {
    // MARK: Constants
    let printMilestone = 1000
    let cardsFileName   = "scryfall-all-cards.json"
    let rulingsFileName = "scryfall-rulings.json"
    let setsFileName    = "scryfall-sets.json"
    let keyruneFileName = "keyrune.html"
    let comprehensiveRulesFileName = "MagicCompRules 20190823"
    let setCodesForProcessing:[String]? = nil
    let storeName = "TCGPlayer"
    
    // MARK: Variables
    var tcgplayerAPIToken = ""
    var dateStart = Date()
    let setsModel = SetsViewModel()
    
    // MARK: Database methods
    func checkServerInfo() {
        let viewModel = ServerInfoViewModel()
        
        firstly {
            viewModel.fetchRemoteData()
        }.compactMap { (data, result) in
            try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        }.then { data in
            viewModel.saveLocalData(data: data)
        }.then {
            viewModel.fetchLocalData()
        }.done {
            if let serverInfo = viewModel.allObjects()?.first as? MGServerInfo {
                if serverInfo.scryfallVersion != ManaKit.Constants.ScryfallDate {
                    viewModel.deleteAllCache()
                    self.updateDatabase()
                }
            }
        }.catch { error in
            print(error)
        }
    }

    func createConnection() -> Connection {
        var configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = "192.168.1.182"
        configuration.port = 5432
        configuration.database = "managuide_dev"
        configuration.user = "managuide"
        configuration.credential = .cleartextPassword(password: "DarkC0nfidant")
        configuration.ssl = false
        
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
        
            return connection
        } catch {
            fatalError("\(error)")
        }
    }
    
    private func updateDatabase() {
        startActivity()
        
        firstly {
            self.fetchSetsData()
        }.then {
            self.fetchSetSymbols()
        }.then {
            self.fetchCardsData()
        }.then {
            self.fetchRulings()
        }.then {
            self.createPGData()
        }.then {
            self.createOtherPGData()
        }.then {
            self.createPricingData()
        }.then {
            self.createScryfallPromise()
        }.done {
            self.endActivity()
        }.catch { error in
            print(error)
        }
    }

    private func createPGData() -> Promise<Void> {
        return Promise { seal in
            let connection = createConnection()
            
            
            let setsArray = self.setsData()
            let cardsArray = self.cardsData()
            let rulingsArray = self.rulingsData()
            let rulesArray = self.rulesData()
            var promises = [()->Promise<Void>]()
            
            // sets
            promises.append(contentsOf: self.filterSetBlocks(array: setsArray, connection: connection))
            promises.append(contentsOf: self.filterSetTypes(array: setsArray, connection: connection))
            promises.append(contentsOf: self.filterSets(array: setsArray, connection: connection))
            promises.append(contentsOf: self.createKeyrunePromises(array: setsArray, connection: connection))

            // cards
            promises.append(contentsOf: self.filterArtists(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterRarities(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterLanguages(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterWatermarks(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterLayouts(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterFrames(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterFrameEffects(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterColors(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterFormats(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterLegalities(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterTypes(array: cardsArray, connection: connection))
            promises.append(contentsOf: self.filterComponents(array: cardsArray, connection: connection))
            promises.append(contentsOf: cardsArray.map { dict in
                return {
                    return self.createCardPromise(dict: dict, connection: connection)
                }
            })

            // parts
            promises.append({
                return self.createDeletePartsPromise(connection: connection)

            })
            promises.append(contentsOf: self.filterParts(array: cardsArray, connection: connection))

            // faces
            promises.append({
                return self.createDeleteFacesPromise(connection: connection)

            })
            promises.append(contentsOf: self.filterFaces(array: cardsArray, connection: connection))

            // rulings
            promises.append({
                return self.createDeleteRulingsPromise(connection: connection)

            })
            promises.append(contentsOf: rulingsArray.map { dict in
                return {
                    return self.createRulingPromise(dict: dict, connection: connection)
                }
            })
            
            // rules
            promises.append({
                return self.createDeleteRulesPromise(connection: connection)

            })
            promises.append(contentsOf: self.filterRules(lines: rulesArray, connection: connection))

            let completion = {
                connection.close()
                seal.fulfill(())
            }
            self.execInSequence(promises: promises,
                                completion: completion)
        }
    }
    
    private func createOtherPGData() -> Promise<Void> {
        return Promise { seal in
            
            let promises = [createOtherLanguagesPromise(),
                            createOtherPrintingsPromise(),
                            createVariationsPromise()]
            
            firstly {
                when(fulfilled: promises)
            }.done {
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func createPricingData() -> Promise<Void> {
        return Promise { seal in
            let connection = createConnection()
            
            firstly {
                self.createStorePromise(name: self.storeName,
                                        connection: connection)
                
            }.then {
                self.getTcgPlayerToken()
            }.then {
                self.fetchSets()
            }.then { groupIds in
                self.fetchTcgPlayerCardPricing(groupIds: groupIds, connection: connection)
            }.done { promises in
                let completion = {
                    connection.close()
                    seal.fulfill(())
                }
                self.execInSequence(promises: promises,
                                    completion: completion)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    // MARK: Promise methods
    func createPromise(with query: String, parameters: [Any]?, connection: Connection?) -> Promise<Void> {
        return Promise { seal in
            if let connection = connection {
                execPG(query: query,
                       parameters: parameters,
                       connection: connection)
                seal.fulfill(())
                
            } else {
                let conn = createConnection()
                
                execPG(query: query,
                       parameters: parameters,
                       connection: conn)
                conn.close()
                seal.fulfill(())
            }
        }
    }
    
    private func execPG(query: String, parameters: [Any]?, connection: Connection) {
        do {
            let statement = try connection.prepareStatement(text: query)
            
            if let parameters = parameters {
                var convertibles = [PostgresValueConvertible]()
                for parameter in parameters {
                    if let c = parameter as? PostgresValueConvertible {
                        convertibles.append(c)
                    }
                }
                
                try statement.execute(parameterValues: convertibles)
            } else {
                try statement.execute()
            }
            
            statement.close()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func execInSequence(promises: [()->Promise<Void>], completion: @escaping () -> Void) {
        var promise = promises.first!()

        let countTotal = promises.count
        var countIndex = 0

        print("Start execInSequence: \(countIndex)/\(countTotal) \(Date())")
        for next in promises {
            promise = promise.then { n -> Promise<Void> in
                countIndex += 1

                if countIndex % self.printMilestone == 0 {
                    print("Exec... \(countIndex)/\(countTotal) \(Date())")
                }
                return next()
            }
        }
        promise.done {_ in
            print("Done execInSequence: \(countIndex)/\(countTotal) \(Date())")
            completion()
        }.catch { error in
            print(error)
            completion()
        }
    }
    
    // MARK: Utility methods
    func sectionFor(name: String) -> String? {
        if name.count == 0 {
            return nil
        } else {
            let letters = CharacterSet.letters
            var prefix = String(name.prefix(1))
            if prefix.rangeOfCharacter(from: letters) == nil {
                prefix = "#"
            }
            return prefix.uppercased().folding(options: .diacriticInsensitive, locale: .current)
        }
    }
    
    func displayFor(name: String) -> String {
        var display = ""
        let components = name.components(separatedBy: "_")
        
        if components.count > 1 {
            for e in components {
                var cap = e
                
                if e != "the" || e != "a" || e != "an" || e != "and" {
                    cap = e.prefix(1).uppercased() + e.dropFirst()
                }
                if display.count > 0 {
                    display.append(" ")
                }
                display.append(cap)
            }
        } else {
            display = name
        }
        
        return display
    }
    
    func capitalize(string: String) -> String {
        if string.count == 0 {
            return string
        } else {
            return (string.prefix(1).uppercased() + string.dropFirst()).replacingOccurrences(of: "_", with: " ")
        }
    }
    
    /*
     * Converts @param string into double equivalents i.e. 100.1a = 100.197
     * Useful for ordering in NSSortDescriptor.
     */
    func order(of string: String) -> Double {
        var termOrder = Double(0)
        
        if let num = Double(string) {
            termOrder = num
        } else {
            let digits = NSCharacterSet.decimalDigits
            var numString = ""
            var charString = ""
            
            for c in string.unicodeScalars {
                if c == "." || digits.contains(c) {
                    numString.append(String(c))
                } else {
                    charString.append(String(c))
                }
            }
            
            if let num = Double(numString) {
                termOrder = num
            }
            
            if charString.count > 0 {
                for c in charString.unicodeScalars {
                    let s = String(c).unicodeScalars
                    termOrder += Double(s[s.startIndex].value) / 100
                }
            }
        }
        return termOrder
    }
    
    func startActivity() {
        dateStart = Date()
        print("Starting on... \(dateStart)")
    }
    
    func endActivity() {
        let dateEnd = Date()
        let timeDifference = dateEnd.timeIntervalSince(dateStart)
        
        print("Total Time Elapsed on: \(dateStart) - \(dateEnd) = \(format(timeDifference))")
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
    }

    func format(_ interval: TimeInterval) -> String {
        if interval == 0 {
            return "HH:mm:ss"
        }
        
        let seconds = interval.truncatingRemainder(dividingBy: 60)
        let minutes = (interval / 60).truncatingRemainder(dividingBy: 60)
        let hours = (interval / 3600)
        return String(format: "%.2d:%.2d:%.2d", Int(hours), Int(minutes), Int(seconds))
    }
}

