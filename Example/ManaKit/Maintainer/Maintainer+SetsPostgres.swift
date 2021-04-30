//
//  Maintainer+SetsPostgres.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 10/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Kanna
import ManaKit
import PostgresClientKit
import PromiseKit

extension Maintainer {
    func createSetBlockPromise(blockCode: String, block: String) -> Promise<Void> {
        let nameSection = self.sectionFor(name: block) ?? "NULL"
        
        let query = "SELECT createOrUpdateSetBlock($1,$2,$3)"
        let parameters = [blockCode,
                          block,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters)
    }

    func createSetTypePromise(setType: String) -> Promise<Void> {
        let capName = capitalize(string: self.displayFor(name: setType))
        let nameSection = self.sectionFor(name: setType) ?? "NULL"
        
        let query = "SELECT createOrUpdateSetType($1,$2)"
        let parameters = [capName,
                          nameSection]
        return createPromise(with: query,
                             parameters: parameters)
    }
    
    func createSetPromise(dict: [String: Any]) -> Promise<Void> {
        let cardCount = dict["card_count"] as? Int ?? Int(0)
        let code = dict["code"] as? String ?? "NULL"
        let isFoilOnly = dict["foil_only"] as? Bool ?? false
        let isOnlineOnly = dict["digital"] as? Bool ?? false
        let mtgoCode = dict["mtgo_code"] as? String ?? "NULL"
        let keyruneUnicode = "e684"
        let keyruneClass = "pmtg1"
        var myNameSection = "NULL"
        if let name = dict["name"] as? String {
            myNameSection = sectionFor(name: name) ?? "NULL"
        }
        var myYearSection = "Undated"
        if let releaseDate = dict["released_at"] as? String {
            myYearSection = String(releaseDate.prefix(4))
        }
        let name = dict["name"] as? String ?? "NULL"
        let releaseDate = dict["released_at"] as? String ?? "NULL"
        let tcgplayerId = dict["tcgplayer_id"] as? Int ?? Int(0)
        let cmsetblock = dict["block_code"] as? String ?? "NULL"
        var setTypeCap = "NULL";
        if let setType = dict["set_type"] as? String {
            setTypeCap = capitalize(string: self.displayFor(name: setType))
        }
        let setParent = dict["parent_set_code"] as? String ?? "NULL"
        
        let query = "SELECT createOrUpdateSet($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)"
        let parameters = [cardCount,
                          code,
                          isFoilOnly,
                          isOnlineOnly,
                          mtgoCode,
                          keyruneUnicode,
                          keyruneClass,
                          myNameSection,
                          myYearSection,
                          name,
                          releaseDate,
                          tcgplayerId,
                          cmsetblock,
                          setTypeCap,
                          setParent] as [Any]
        return createPromise(with: query,
                             parameters: parameters)
    }
    
    func createKeyrunePromises(array: [[String: Any]]) -> [()->Promise<Void>] {
        let document = keyruneCodes()
        var keyrunes = [String: [String]]()
        
        for div in document.xpath("//div[@class='vectors']") {
            for span in div.xpath("//span") {
                if let content = span.content {
                    let components = content.components(separatedBy: " ")
                    
                    if components.count == 3 {
                        let setCode = components[1].replacingOccurrences(of: "ss-", with: "")
                        let keyruneUnicode = components[2].replacingOccurrences(of: "&#x", with: "").replacingOccurrences(of: ";", with: "")
                        keyrunes[setCode] = [keyruneUnicode, setCode]
                    }
                }
            }
        }
        
        var promises: [()->Promise<Void>] = keyrunes.map { (setCode, array) in
            return {
                return self.createKeyruneCodePromise(code: setCode,
                                                     keyruneUnicode: array.first ?? "NULL" ,
                                                     keyruneClass: array.last ?? "NULL")
            }
        }
        
        keyrunes = updatableKeyruneCodes(array: array)
        promises.append(contentsOf: keyrunes.map { (setCode, array) in
            return {
                return self.createKeyruneCodePromise(code: setCode,
                                                     keyruneUnicode: array.first ?? "NULL" ,
                                                     keyruneClass: array.last ?? "NULL")
            }
        })
        
        return promises
    }
    
    func keyruneCodes() -> HTMLDocument {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError("Malformed cachePath")
        }
        let keyrunePath = "\(cachePath)/\(ManaKit.Constants.ScryfallDate)_\(keyruneFileName)"
        let url = URL(fileURLWithPath: keyrunePath)
        
        return try! HTML(url: url, encoding: .utf8)
    }
    
    func updatableKeyruneCodes(array: [[String: Any]]) -> [String: [String]] {
        var keyruneCodes = [String: [String]]()
        
        // manual fix
        for dict in array {
            if let code = dict["code"] as? String {
                if code == "plist" {
                   keyruneCodes[code] = ["e971", "mb1"] // plist
                } else if code == "tznr" ||
                   code == "aznr" ||
                   code == "pznr" ||
                   code == "sznr" ||
                   code == "mznr" {
                   keyruneCodes[code] = ["e963", "znr"] // Zendikar Rising Tokens
                } else if code == "zne" {
                  keyruneCodes[code] = ["e97a", "zne"]  // Zendikar Rising Expeditions
                } else if code == "2xm" ||
                   code == "t2xm" {
                   keyruneCodes[code] = ["e96e", "2xm"] // double masters
                } else if code == "jmp" ||
                   code == "ajmp" ||
                   code == "fjmp" {
                   keyruneCodes[code] = ["e96f", "jmp"] // jump start
                } else if code == "m21" ||
                   code == "tm21" ||
                   code == "pm21" {
                   keyruneCodes[code] = ["e960", "m21"] // m21
                } else if code == "ha1" ||
                    code == "ha2" ||
                    code == "ha3" {
                   keyruneCodes[code] = ["e96b", "ha1"] // historic antology
                } else if code == "c14" ||
                    code == "oc14" ||
                    code == "tc14" {
                    keyruneCodes[code] = ["e65d", "c14"] // typo in website
                 } else if code == "plny" ||
                    code == "f11" ||
                    code == "f12" ||
                    code == "f13" ||
                    code == "f14" ||
                    code == "f15" ||
                    code == "f16" ||
                    code == "f17" ||
                    code == "f18" ||
                    code == "hho" ||
                    code == "j13" ||
                    code == "j14" ||
                    code == "j15" ||
                    code == "j16" ||
                    code == "j17" ||
                    code == "j18" ||
                    code == "olgc" ||
                    code == "pnat" ||
                    code == "ppro" ||
                    code == "pres" ||
                    code == "purl" ||
                    code == "ovnt" ||
                    code == "pwp11" ||
                    code == "pwp12" ||
                    code == "pwcq" ||
                    code == "pf19" ||
                    code == "j12" ||
                    code == "j19" ||
                    code == "ppp1" ||
                    code == "pf20" ||
                    code == "sld" ||
                    code == "psld" ||
                    code == "j20" ||
                    code == "htr18" ||
                    code == "slu" ||
                    code == "plgs" ||
                    code == "g17" {
                    keyruneCodes[code] = ["e687", "pmei"]  // media insert
                 } else if code == "pal99" {
                    keyruneCodes[code] = ["e622", "usg"]  // urza's saga
                 } else if code == "pal01"  ||
                    code == "pal00" {
                    keyruneCodes[code] = ["e68c", "parl2"]  // arena league
                 } else if code == "pal02" ||
                    code == "pal03" ||
                    code == "pal04" ||
                    code == "pal06" ||
                    code == "f01" ||
                    code == "f02" ||
                    code == "f03" ||
                    code == "f04" ||
                    code == "f05" ||
                    code == "f06" ||
                    code == "f07" ||
                    code == "f08" ||
                    code == "f09" ||
                    code == "f10" ||
                    code == "pgtw" ||
                    code == "pg07" ||
                    code == "pg08" ||
                    code == "g00" ||
                    code == "g01" ||
                    code == "g02" ||
                    code == "g03" ||
                    code == "g04" ||
                    code == "g05" ||
                    code == "g06" ||
                    code == "g07" ||
                    code == "g08" ||
                    code == "g09" ||
                    code == "g10" ||
                    code == "pjas" ||
                    code == "pjse" ||
                    code == "psus" ||
                    code == "mpr" ||
                    code == "pr2" ||
                    code == "p03" ||
                    code == "p04" ||
                    code == "p05" ||
                    code == "p06" ||
                    code == "phop" ||
                    code == "parc" ||
                    code == "p2hg" ||
                    code == "pwpn" ||
                    code == "pwp09" ||
                    code == "pwp10" ||
                    code == "pal05" {
                    keyruneCodes[code] = ["e688", "parl"]  // dci
                } else if code == "ana" ||
                    code == "anb"{
                    keyruneCodes[code] = ["e943", "parl3"]  // arena league
                } else if code == "ced" {
                    keyruneCodes[code] = ["e926", "xcle"]  // CE
                } else if code == "dvd" ||
                    code == "tdvd"{
                    keyruneCodes[code] = ["e66b", "ddc"] // divine vs demonic
                } else if code == "gvl" ||
                    code == "tgvl"{
                    keyruneCodes[code] = ["e66c", "ddd"]  // garruk vs liliana
                } else if code == "jvc" ||
                    code == "tjvc"{
                    keyruneCodes[code] = ["e66a", "dd2"]  // jace vs chandra
                } else if code == "dd1" {
                    keyruneCodes[code] = ["e669", "evg"]  // elves vs goblins
                } else if code == "pdtp" {
                    keyruneCodes[code] = ["e915", "pxbox"]  // xbox media promo
                } else if code == "pdp12" {
                    keyruneCodes[code] = ["e60f", "m13"]  // m13
                } else if code == "pdp13" {
                    keyruneCodes[code] = ["e610", "m14"]  // m14
                } else if code == "pdp14" {
                    keyruneCodes[code] = ["e611", "m15"]  // m15
                } else if code == "fbb" {
                    keyruneCodes[code] = ["e603", "3ed"]  // revised / 3ed
                } else if code == "phuk" ||
                    code == "psal" {
                    keyruneCodes[code] = ["e909", "psalvat05"]  // Salvat 2005
                } else if code == "phpr" ||
                    code == "pbok" {
                    keyruneCodes[code] = ["e68a", "pbook"]  // book inserts
                } else if code == "pi13" ||
                    code == "pi14" {
                    keyruneCodes[code] = ["e92c", "pidw"]  // IDW promo
                } else if code == "cei" {
                    keyruneCodes[code] = ["e927", "xice"]  // cei
                } else if code == "pmoa" ||
                    code == "prm" {
                    keyruneCodes[code] = ["e91b", "pmodo"]  // magic online
                } else if code == "td0" {
                    keyruneCodes[code] = ["e91e", "xmods"]  // magic online deck series
                } else if code == "ren" ||
                    code == "rin" {
                    keyruneCodes[code] = ["e917", "xren"]  // rennaisance
                } else if code == "pmps07" ||
                    code == "pmps08" ||
                    code == "pmps09" ||
                    code == "pmps10" ||
                    code == "pmps11" {
                    keyruneCodes[code] = ["e919", "pmps"]  // magic premiere shop
                } else if code == "ps11" {
                    keyruneCodes[code] = ["e90a", "psalvat11"]  // Salvat 2011
                } else if code == "sum" {
                    keyruneCodes[code] = ["e605", "psum"]  // Summer Magic / Edgar
                } else if code == "peld" ||      // Throne of Eldraine
                    code == "teld" {
                    keyruneCodes[code] = ["e95e", "eld"]
                } else if code == "peld" ||      // Throne of Eldraine
                    code == "teld" {
                    keyruneCodes[code] = ["e95e", "eld"]
                } else if code == "4bb" {      // IV Ed
                    keyruneCodes[code] = ["e604", "4ed"]
                } else if code == "pelp" {     // Euro Land Program
                    keyruneCodes[code] = ["e92b", "peuro"]
                } else if code == "fnm" {      // FNM
                    keyruneCodes[code] = ["e937", "pfnm"]
                } else if code == "palp" {     // APAC
                    keyruneCodes[code] = ["e92a", "papac"]
                } else if code == "pvan" {     // Vanguard Series
                    keyruneCodes[code] = ["e655", "van"]
                } else if code == "itp" {      // Introductory Two-Player Set
                    keyruneCodes[code] = ["e928", "x2ps"]
                } else if code == "mgb" {      // Multiverse Gift Box
                    keyruneCodes[code] = ["e61d", "vis"]
                }
            }
        }
            
        return keyruneCodes
    }
    
    private func createKeyruneCodePromise(code: String, keyruneUnicode: String, keyruneClass: String) -> Promise<Void> {
        let query = "SELECT updateSetKeyrune($1,$2,$3)"
        let parameters = [code,
                          keyruneUnicode,
                          keyruneClass]
        return createPromise(with: query,
                             parameters: parameters)
    }
}
