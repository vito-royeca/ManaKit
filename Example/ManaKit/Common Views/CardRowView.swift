//
//  CardRowView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 1/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit
import SDWebImageSwiftUI


struct CardRowView: View {
    private let card: MCard
    private var nameFont: Font
    
    init(card: MCard) {
        self.card = card
        
        let font = card.nameFont()
        nameFont = Font.custom(font.name, size: font.size)
    }
    
    var body: some View {
        HStack(spacing: 10) {
//            ZStack(alignment: .bottomTrailing) {
                WebImage(url: card.imageURL(for: .artCrop))
                    .resizable()
//                    .placeholder(Image("cropback-hq", bundle: .main))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                
//                Text(card.displayKeyrune)
//                    .scaledToFit()
//                    .font(Font.custom("Keyrune", size: 30))
//                    .foregroundColor(Color(card.keyruneColor()))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
//            }
            
            VStack(alignment: .leading) {
                Text(card.displayName)
                    .font(nameFont)
                
                HStack {
                    Text(card.displayTypeLine)
                        .font(.footnote)

                    if !card.displayPowerToughness.isEmpty {
                        Spacer()
                        Text(card.displayPowerToughness)
                            .font(.footnote)
                    }
                }
                
                HStack {
                    Text(card.displayKeyrune)
                        .scaledToFit()
                        .font(Font.custom("Keyrune", size: 30))
                        .foregroundColor(Color(card.keyruneColor()))

                    if let manaCost = card.manaCost {
                        Spacer()
                        AttributedText(
                            NSAttributedString(symbol: manaCost, pointSize: 16)
                        )
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                HStack {
                    Text("Normal \(card.displayNormalPrice)")
                    Spacer()
                    Text("Foil \(card.displayFoilPrice)")
                }
            }
        }
    }
}

//struct CardRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        let card = MCard()
//        let view = CardRowView(card: card)
//        
//        return view
//    }
//}
