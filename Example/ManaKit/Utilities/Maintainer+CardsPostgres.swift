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
import RealmSwift

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
            first_name = names.first ?? "null"
            name_section = first_name
        }
        name_section = sectionFor(name: name_section) ?? "null"
        
        let parameters = """
                         name=\(artist)&
                         first_name=\(first_name)&
                         last_name=\(last_name)&
                         name_section=\(name_section)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/artists"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createRarityPromise(rarity: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: rarity))
        let nameSection = sectionFor(name: rarity) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/rarities"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createLanguagePromise(code: String, displayCode: String, name: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         code=\(code)&
                         display_code=\(displayCode)&
                         name=\(name)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/languages"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createLayoutPromise(name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)&
                         description_=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/layouts"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createWatermarkPromise(watermark: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: watermark))
        let nameSection = sectionFor(name: watermark) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/watermarks"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createFramePromise(name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)&
                         description_=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/frames"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createFrameEffectPromise(id: String, name: String, description_: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         id=\(id)&
                         name=\(name)&
                         name_section=\(nameSection)&
                         description_=\(description_)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/frameeffects"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createColorPromise(symbol: String, name: String, isManaColor: Bool) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         symbol=\(symbol)&
                         name=\(name)&
                         name_section=\(nameSection)&
                         is_mana_color=\(isManaColor)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/colors"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createFormatPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/formats"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createLegalityPromise(name: String) -> Promise<(data: Data, response: URLResponse)> {
        let capName = capitalize(string: displayFor(name: name))
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         name=\(capName)&
                         name_section=\(nameSection)
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/legalities"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createCardTypePromise(name: String, parent: String) -> Promise<(data: Data, response: URLResponse)> {
        let nameSection = sectionFor(name: name) ?? "null"
        
        let parameters = """
                         name=\(name)&
                         name_section=\(nameSection)&
                         cmcardtype_parent=\(parent)&
                         """
        let urlString = "\(ManaKit.Constants.APIURL)/cardtypes"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
    
    func createCardPromise(dict: [String: Any]) -> Promise<(data: Data, response: URLResponse)> {
        let collector_number = dict["collector_number"] ?? "null"
        let cmc = dict["cmc"] ?? Double(0)
        let flavor_text = dict["flavor_text"] ?? "null"
        var image_uris = "null"
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
        let loyalty = dict["loyalty"] ?? "null"
        let mana_cost = dict["mana_cost"] ?? "null"
        var multiverse_ids = "{}"
        if let a = dict["multiverse_ids"] as? [Int],
            !a.isEmpty {
            multiverse_ids = "\(a)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        var my_name_section = "null";
        if let name = dict["name"] as? String {
            my_name_section = self.sectionFor(name: name) ?? "null"
        }
        let name = dict["name"] ?? "null"
        let oracle_text = dict["oracle_text"] ?? "null"
        let power = dict["power"] ?? "null"
        let printed_name = dict["printed_name"] ?? "null"
        let printed_text = dict["printed_text"] ?? "null"
        let toughness = dict["toughness"] ?? "null"
        let arena_id = dict["arena_id"] ?? "null"
        let mtgo_id = dict["mtgo_id"] ?? "null"
        let tcgplayer_id = dict["tcgplayer_id"] ?? "null"
        let hand_modifier = dict["hand_modifier"] ?? "null"
        let life_modifier = dict["life_modifier"] ?? "null"
        let is_booster = dict["booster"] ?? false
        let is_digital = dict["digital"] ?? false
        let is_promo = dict["promo"] ?? false
        let released_at = dict["released_at"] ?? "null"
        let is_textless = dict["textless"] ?? false
        let is_variation = dict["variation"] ?? false
        let mtgo_foil_id = dict["mtgo_foil_id"] ?? "null"
        let is_reprint = dict["reprint"] ?? false
        let id = dict["id"] ?? "null"
        let card_back_id = dict["card_back_id"] ?? "null"
        let oracle_id = dict["oracle_id"] ?? "null"
        let illustration_id = dict["illustration_id"] ?? "null"
        let cmartist = dict["artist"] ?? "null"
        let cmset = dict["set"] ?? "null"
        let cmrarity = capitalize(string: dict["rarity"] as? String ?? "null")
        let cmlanguage = dict["lang"] ?? "null"
        let cmlayout = capitalize(string: dict["layout"] as? String ?? "null")
        let cmwatermark = capitalize(string: dict["watermark"] as? String ?? "null")
        let cmframe = capitalize(string: dict["frame"] as? String ?? "null")
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
        var cmlegalities = "null"
        if let legalities = dict["legalities"] as? [String: String] {
            var newLegalities = [String: String]()
            for (k,v) in legalities {
                newLegalities[capitalize(string: displayFor(name: k))] = capitalize(string: displayFor(name: v))
            }
            cmlegalities = "\(newLegalities)"
                .replacingOccurrences(of: "[", with: "{")
                .replacingOccurrences(of: "]", with: "}")
        }
        let type_line = dict["type_line"] ?? "null"
        let printed_type_line = dict["printed_type_line"] ?? "null"
        
        // unhandled...
        // all_parts
        // card_faces
        // border_color
        // games
        // promo_types
        // variation_of
        // preview.previewed_at
        // preview.source_uri
        // preview.source
        // related cards
//                /// cached data here ///
//
        //            try! realm.write {
        //                for x in cachedCardTypes {
        //                    realm.add(x)
        //                }
        //                for x in cachedBorderColors {
        //                    realm.add(x)
        //                }
        //                for x in cachedRulings {
        //                    realm.add(x)
        //                }

//                // border color
//                if let borderColor = dict["border_color"] as? String,
//                    let x = findCardBorderColor(with: borderColor) {
//                    card.borderColor = x
//                }
//
        let parameters =
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
            is_variation=\(is_variation)&
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
            printed_type_line=\(printed_type_line)
            """
        let urlString = "\(ManaKit.Constants.APIURL)/cards"
        
        return createNodePromise(urlString: urlString, parameters: parameters)
    }
}
