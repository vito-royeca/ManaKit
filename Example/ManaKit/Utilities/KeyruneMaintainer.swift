//
//  KeyruneMaintainer.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import Kanna
import ManaKit
import PromiseKit

class KeyruneMaintainer: Maintainer {
    func updateSetSymbols() {
        startActivity(name: "updateSetSymbols")
        
        if let urlString = "http://andrewgioia.github.io/Keyrune/cheatsheet.html".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            
            firstly {
                URLSession.shared.dataTask(.promise, with:rq)
            }.map {
                try! HTML(html: $0.data, encoding: .utf8)
            }.done { html in
                self.process(document: html)
                self.endActivity()
            }.catch { error in
                print("\(error)")
            }
        }
    }
    
    private func process(document: HTMLDocument) {
        let context = ManaKit.sharedInstance.memoryDataStack!.mainContext
        
        for div in document.xpath("//div[@class='vectors']") {
            for span in div.xpath("//span") {
                if let content = span.content {
                    let array = content.components(separatedBy: " ")
                    if array.count == 3 {
                        let setCode = array[1].replacingOccurrences(of: "ss-", with: "")
                        var keyruneCode = array[2].replacingOccurrences(of: "&#x", with: "").replacingOccurrences(of: ";", with: "")
                        
                        // fixes
                        if setCode == "c14" {
                            keyruneCode = "e65d"
                        }
                        
                        if let set = ManaKit.sharedInstance.findObject("CMSet",
                                                                       objectFinder: ["code": setCode] as [String: AnyObject],
                                                                       createIfNotFound: false,
                                                                       useInMemoryDatabase: useInMemoryDatabase) as? CMSet {
                            set.myKeyruneCode = keyruneCode
                        }
                    }
                }
            }
        }
        try! context.save()
        
        // update keyrune of children
        let request: NSFetchRequest<CMSet> = CMSet.fetchRequest()
        request.predicate = NSPredicate(format: "parent != nil AND myKeyruneCode = nil")
        var sets = try! context.fetch(request)
        for set in sets {
            if let parent = set.parent {
                set.myKeyruneCode = parent.myKeyruneCode
            }
        }
        try! context.save()
        
        // manual fix
        request.predicate = nil
        sets = try! context.fetch(request)
        for set in sets {
            if set.code == "pgp17" ||
                set.code == "htr" ||
                set.code == "plny" ||
                set.code == "f11" ||
                set.code == "f12" ||
                set.code == "f13" ||
                set.code == "f14" ||
                set.code == "f15" ||
                set.code == "f16" ||
                set.code == "f17" ||
                set.code == "f18" ||
                set.code == "hho" ||
                set.code == "j13" ||
                set.code == "j14" ||
                set.code == "j15" ||
                set.code == "j16" ||
                set.code == "j17" ||
                set.code == "j18" ||
                set.code == "olgc" ||
                set.code == "pnat" ||
                set.code == "ppro" ||
                set.code == "pres" ||
                set.code == "purl" ||
                set.code == "ovnt" ||
                set.code == "pwp11" ||
                set.code == "pwp12" ||
                set.code == "pwcq" {
                set.myKeyruneCode = "e687" // media insert
            } else if set.code == "pal99" {
                set.myKeyruneCode = "e622" // urza's saga
            } else if set.code == "pal01" {
                set.myKeyruneCode = "e68c" // arena
            } else if set.code == "pal02" ||
                set.code == "pal03" ||
                set.code == "pal04" ||
                set.code == "pal06" ||
                set.code == "f01" ||
                set.code == "f02" ||
                set.code == "f03" ||
                set.code == "f04" ||
                set.code == "f05" ||
                set.code == "f06" ||
                set.code == "f07" ||
                set.code == "f08" ||
                set.code == "f09" ||
                set.code == "f10" ||
                set.code == "pgtw" ||
                set.code == "pg07" ||
                set.code == "pg08" ||
                set.code == "g00" ||
                set.code == "g01" ||
                set.code == "g02" ||
                set.code == "g03" ||
                set.code == "g04" ||
                set.code == "g05" ||
                set.code == "g06" ||
                set.code == "g07" ||
                set.code == "g08" ||
                set.code == "g09" ||
                set.code == "g10" ||
                set.code == "pjas" ||
                set.code == "pjse" ||
                set.code == "psus" ||
                set.code == "mpr" ||
                set.code == "pr2" ||
                set.code == "p03" ||
                set.code == "p04" ||
                set.code == "p05" ||
                set.code == "p06" ||
                set.code == "phop" ||
                set.code == "parc" ||
                set.code == "p2hg" ||
                set.code == "pwpn" ||
                set.code == "pwp09" ||
                set.code == "pwp10" {
                set.myKeyruneCode = "e688" // dci
            } else if set.code == "ana" {
                set.myKeyruneCode = "e943" // arena league
            } else if set.code == "palp" {
                set.myKeyruneCode = "e92a" // apac lands
            } else if set.code == "ced" {
                set.myKeyruneCode = "e926" // CE
            } else if set.code == "dvd" ||
                set.code == "tdvd"{
                set.myKeyruneCode = "e66b" // divine vs demonic
            } else if set.code == "gvl" ||
                set.code == "tgvl"{
                set.myKeyruneCode = "e66c" // garruk vs liliana
            } else if set.code == "jvc" ||
                set.code == "tjvc"{
                set.myKeyruneCode = "e66a" // jace vs chandra
            } else if set.code == "dd1" {
                set.myKeyruneCode = "e669" // elves vs goblins
            } else if set.code == "pdtp" {
                set.myKeyruneCode = "e915" // xbox media promo
            } else if set.code == "pdp12" {
                set.myKeyruneCode = "e60f" // m13
            } else if set.code == "pdp13" {
                set.myKeyruneCode = "e610" // m14
            } else if set.code == "pdp14" {
                set.myKeyruneCode = "e611" // m15
            } else if set.code == "pelp" {
                set.myKeyruneCode = "e92b" // euro lands
            } else if set.code == "fbb" {
                set.myKeyruneCode = "e603" // revised / 3ed
            } else if set.code == "phuk" ||
                set.code == "psal" {
                set.myKeyruneCode = "e909" // Salvat 2005
            } else if set.code == "phpr" ||
                set.code == "pbok" {
                set.myKeyruneCode = "e68a" // book inserts
            } else if set.code == "pi13" ||
                set.code == "pi14" {
                set.myKeyruneCode = "e92c" // IDW promo
            } else if set.code == "cei" {
                set.myKeyruneCode = "e927" // cei
            } else if set.code == "itp" {
                set.myKeyruneCode = "e928" // intro. two player set
            } else if set.code == "pmoa" ||
                set.code == "prm" {
                set.myKeyruneCode = "e91b" // magic online
            } else if set.code == "td0" {
                set.myKeyruneCode = "e91e" // magic online deck series
            } else if set.code == "ren" ||
                set.code == "rin" {
                set.myKeyruneCode = "e917" // rennaisance
            } else if set.code == "pmps07" ||
                set.code == "pmps08" ||
                set.code == "pmps09" ||
                set.code == "pmps10" ||
                set.code == "pmps11" {
                set.myKeyruneCode = "e919" // magic premiere shop
            } else if set.code == "ps11" {
                set.myKeyruneCode = "e90a" // Salvat 2011
            } else {
                if set.code == nil {
                    set.myKeyruneCode = "e684" //
                }
            }
        }
        try! context.save()
    }
}
