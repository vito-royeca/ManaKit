//
//  Maintainer+CardsPostgres.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 10/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ManaKit
import PromiseKit
import SwiftKuery
import SwiftKueryPostgreSQL

extension Maintainer {
    func createArtistPromise(artist: String) -> Promise<(data: Data, response: URLResponse)> {
        let names = artist.components(separatedBy: " ")
        var first_name = ""
        var last_name = ""
        var name_section = ""
        
        if names.count > 1 {
            if let last = names.last {
                last_name = last
                name_section = last_name
            }
            
            for i in 0...names.count - 2 {
                first_name.append("\(names[i])")
                if i != names.count - 2 && names.count >= 3 {
                    first_name.append(" ")
                }
            }
            
        } else {
            first_name = names.first ?? "NULL"
            name_section = first_name
        }
        name_section = sectionFor(name: name_section) ?? "NULL"
        
        let httpBody = """
                        name=\(artist)&
                        first_name=\(first_name)&
                        last_name=\(last_name)&
                        name_section=\(name_section)
                        """
        let urlString = "\(ManaKit.Constants.APIURL)/artists"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createRarityPromise(rarity: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: rarity))
        let nameSection = sectionFor(name: rarity) ?? "NULL"
        
        let httpBody = """
                        name=\(capName)&
                        name_section=\(nameSection)
                        """
        let urlString = "\(ManaKit.Constants.APIURL)/rarities"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createLanguagePromise(code: String, displayCode: String, name: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         code=\(code)&
                         display_code=\(displayCode)&
                         name=\(name)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/languages"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createLayoutPromise(name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)&
                         description=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/layouts"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createWatermarkPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/watermarks"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createFramePromise(name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)&
                         description=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/frames"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createFrameEffectPromise(id: String, name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         id=\(id)&
                         name=\(name)&
                         name_section=\(nameSection)&
                         description=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/frameeffects"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createColorPromise(symbol: String, name: String, isManaColor: Bool) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         symbol=\(symbol)&
                         name=\(name)&
                         name_section=\(nameSection)&
                         is_mana_color=\(isManaColor)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/colors"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createFormatPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/formats"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createLegalityPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/legalities"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createCardTypePromise(name: String, parent: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(name)&
                         name_section=\(nameSection)&
                         cmcardtype_parent=\(parent)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/cardtypes"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createComponentPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "NULL"
        
        let httpBody = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/components"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createDeleteFacesPromise() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/cardfaces"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "DELETE",
                                                        httpBody: nil)
    }
    
    func createFacePromise(card: String, cardFace: String) -> Promise<(data: Data, response: URLResponse)> {
        
        let httpBody = """
                         cmcard=\(card)&
                         cmcard_face=\(cardFace)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/cardfaces"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createDeletePartsPromise() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/cardparts"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "DELETE",
                                                        httpBody: nil)
    }
    
    func createPartPromise(card: String, component: String, cardPart: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: component))
        
        let httpBody = """
                         cmcard=\(card)&
                         cmcomponent=\(capName)&
                         cmcard_part=\(cardPart)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/cardparts"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
    
    func createOtherPrintingsPromise() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/cardotherprintings"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: nil)
    }
    
    func createOtherLanguagesPromise() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/cardotherlanguages"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: nil)
    }
    
    func createVariationsPromise() -> Promise<Void> {
        return Promise { seal in
            connection.connect() { result in
                if !result.success {
                    if let error = result.asError {
                        seal.reject(error)
                        return
                    }
                }
                let callback = { (result: QueryResult) in
                    if !result.success {
                        if let error = result.asError {
                            seal.reject(error)
                            return
                        }
                    }
                    seal.fulfill(())
                }
                self.connection.execute("select createOrUpdateVariations()",
                                        onCompletion: callback)
            }
        }
    }
    
    func createCardPromise(dict: [String: Any]) -> Promise<(data: Data, response: URLResponse)> {
        let collector_number = dict["collector_number"] ?? "NULL"
        let cmc = dict["cmc"] ?? Double(0)
        let flavor_text = dict["flavor_text"] ?? "NULL"
        var image_uris = "{}"
        if let imageUris = dict["image_uris"] as? [String: String] {
            // remove the key (?APIKEY) in the url
            var newImageUris = [String: String]()
            for (k,v) in imageUris {
                newImageUris[k] = v.components(separatedBy: "?").first
            }

            image_uris = "\(newImageUris)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let is_foil = dict["foil"] ?? false
        let is_full_art = dict["full_art"] ?? false
        let is_highres_image = dict["highres_image"] ?? false
        let is_nonfoil = dict["nonfoil"] ?? false
        let is_oversized = dict["oversized"] ?? false
        let is_reserved = dict["reserved"] ?? false
        let is_story_spotlight = dict["story_spotlight"] ?? false
        let loyalty = dict["loyalty"] ?? "NULL"
        let mana_cost = dict["mana_cost"] ?? "NULL"
        var multiverse_ids = "{}"
        if let a = dict["multiverse_ids"] as? [Int],
            !a.isEmpty {
            multiverse_ids = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var my_name_section = "NULL";
        if let name = dict["name"] as? String {
            my_name_section = self.sectionFor(name: name) ?? "NULL"
        }
        let name = dict["name"] ?? "NULL"
        let oracle_text = dict["oracle_text"] ?? "NULL"
        let power = dict["power"] ?? "NULL"
        let printed_name = dict["printed_name"] ?? "NULL"
        let printed_text = dict["printed_text"] ?? "NULL"
        let toughness = dict["toughness"] ?? "NULL"
        let arena_id = dict["arena_id"] ?? "NULL"
        let mtgo_id = dict["mtgo_id"] ?? "NULL"
        let tcgplayer_id = dict["tcgplayer_id"] ?? "NULL"
        let hand_modifier = dict["hand_modifier"] ?? "NULL"
        let life_modifier = dict["life_modifier"] ?? "NULL"
        let is_booster = dict["booster"] ?? false
        let is_digital = dict["digital"] ?? false
        let is_promo = dict["promo"] ?? false
        let released_at = dict["released_at"] ?? "NULL"
        let is_textless = dict["textless"] ?? false
        let mtgo_foil_id = dict["mtgo_foil_id"] ?? "NULL"
        let is_reprint = dict["reprint"] ?? false
        let id = dict["id"] ?? "NULL"
        let card_back_id = dict["card_back_id"] ?? "NULL"
        let oracle_id = dict["oracle_id"] ?? "NULL"
        let illustration_id = dict["illustration_id"] ?? "NULL"
        let cmartist = dict["artist"] ?? "NULL"
        let cmset = dict["set"] ?? "NULL"
        let cmrarity = capitalize(string: dict["rarity"] as? String ?? "NULL")
        let cmlanguage = dict["lang"] ?? "NULL"
        let cmlayout = capitalize(string: displayFor(name: dict["layout"] as? String ?? "NULL"))//capitalize(string: dict["layout"] as? String ?? "NULL")
        let cmwatermark = capitalize(string: dict["watermark"] as? String ?? "NULL")
        let cmframe = capitalize(string: dict["frame"] as? String ?? "NULL")
        var cmframe_effects = "{}"
        if let a = dict["frame_effects"] as? [String],
            !a.isEmpty {
            cmframe_effects = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cmcolors = "{}"
        if let a = dict["colors"] as? [String],
            !a.isEmpty {
            cmcolors = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cmcolor_identities = "{}"
        if let a = dict["color_identity"] as? [String],
            !a.isEmpty {
            cmcolor_identities = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cmcolor_indicators = "{}"
        if let a = dict["color_indicator"] as? [String],
            !a.isEmpty {
            cmcolor_indicators = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cmlegalities = "{}"
        if let legalities = dict["legalities"] as? [String: String] {
            var newLegalities = [String: String]()
            for (k,v) in legalities {
                newLegalities[capitalize(string: displayFor(name: k))] = capitalize(string: displayFor(name: v))
            }
            cmlegalities = "\(newLegalities)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let type_line = dict["type_line"] ?? "NULL"
        let printed_type_line = dict["printed_type_line"] ?? "NULL"
        var cmcardtype_subtypes = "{}"
        if let tl = dict["type_line"] as? String {
            let subtypes = extractSubtypesFrom(tl)
            cmcardtype_subtypes = "\(subtypes)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var cmcardtype_supertypes = "{}"
        if let tl = dict["type_line"] as? String {
            let supertypes = extractSupertypesFrom(tl)
            cmcardtype_supertypes = "\(supertypes)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let face_order = dict["face_order"] ?? 0
        
        // unhandled...
        // border_color
        // games
        // promo_types
        // preview.previewed_at
        // preview.source_uri
        // preview.source
        let httpBody =
            """
            collector_number=\(collector_number)&
            cmc=\(cmc)&
            flavor_text=\(flavor_text)&
            image_uris=\(image_uris)&
            is_foil=\(is_foil)&
            is_full_art=\(is_full_art)&
            is_highres_image=\(is_highres_image)&
            is_nonfoil=\(is_nonfoil)&
            is_oversized=\(is_oversized)&
            is_reserved=\(is_reserved)&
            is_story_spotlight=\(is_story_spotlight)&
            loyalty=\(loyalty)&
            mana_cost=\(mana_cost)&
            multiverse_ids=\(multiverse_ids)&
            my_name_section=\(my_name_section)&
            name=\(name)&
            oracle_text=\(oracle_text)&
            power=\(power)&
            printed_name=\(printed_name)&
            printed_text=\(printed_text)&
            toughness=\(toughness)&
            arena_id=\(arena_id)&
            mtgo_id=\(mtgo_id)&
            tcgplayer_id=\(tcgplayer_id)&
            hand_modifier=\(hand_modifier)&
            life_modifier=\(life_modifier)&
            is_booster=\(is_booster)&
            is_digital=\(is_digital)&
            is_promo=\(is_promo)&
            released_at=\(released_at)&
            is_textless=\(is_textless)&
            mtgo_foil_id=\(mtgo_foil_id)&
            is_reprint=\(is_reprint)&
            id=\(id)&
            card_back_id=\(card_back_id)&
            oracle_id=\(oracle_id)&
            illustration_id=\(illustration_id)&
            cmartist=\(cmartist)&
            cmset=\(cmset)&
            cmrarity=\(cmrarity)&
            cmlanguage=\(cmlanguage)&
            cmlayout=\(cmlayout)&
            cmwatermark=\(cmwatermark)&
            cmframe=\(cmframe)&
            cmframe_effects=\(cmframe_effects)&
            cmcolors=\(cmcolors)&
            cmcolor_identities=\(cmcolor_identities)&
            cmcolor_indicators=\(cmcolor_indicators)&
            cmlegalities=\(cmlegalities)&
            type_line=\(type_line)&
            printed_type_line=\(printed_type_line)&
            cmcardtype_subtypes=\(cmcardtype_subtypes)&
            cmcardtype_supertypes=\(cmcardtype_supertypes)&
            face_order=\(face_order)
            """
        let urlString = "\(ManaKit.Constants.APIURL)/cards"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "POST",
                                                        httpBody: httpBody)
    }
}
