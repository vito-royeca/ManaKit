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
    private let card: MGCard
    
    init(card: MGCard) {
        self.card = card
    }
    
    var body: some View {
        let font = card.nameFont()

        VStack {
            VStack(alignment: .leading) {
                if let manaCost = card.manaCost {
                    ZStack(alignment: .leading) {
                        Text(card.displayName)
                            .font(Font.custom(font.name, size: font.size))

                        Spacer()
                        AttributedText(
                            NSAttributedString(symbol: manaCost, pointSize: 16)
                        )
                            .multilineTextAlignment(.trailing)
                    }
                } else {
                    Text(card.displayName)
                        .font(Font.custom(font.name, size: font.size))
                }

                HStack(spacing: 10) {
                    ZStack(alignment: .bottomLeading) {
                        WebImage(url: card.imageURL(for: .artCrop))
                            .resizable()
                            .placeholder(Image("cropback-hq", bundle: .main))
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                        
                        if !card.displayPowerToughness.isEmpty {
                            Text(card.displayPowerToughness)
                                .font(.body)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        } else {
                            EmptyView()
                        }
                    }

                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(card.displayTypeLine)
                                .font(.body)
                            Spacer()
                            Text(card.displayKeyrune)
                                .font(Font.custom("Keyrune", size: 20))
                                .foregroundColor(Color(card.keyruneColor()))
                        }

                        Spacer()
                        
                        HStack {
                            Text("Normal")
                                .font(.body)
                                .foregroundColor(Color.blue)
                            Spacer()
                            Text(card.displayNormalPrice)
                                .font(.body)
                                .foregroundColor(Color.blue)
                                .multilineTextAlignment(.trailing)
                        }

                        HStack {
                            Text("Foil")
                                .font(.body)
                                .foregroundColor(Color.green)
                            Spacer()
                            Text(card.displayFoilPrice)
                                .font(.body)
                                .foregroundColor(Color.green)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
                .padding()
        }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 1)
            )
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
