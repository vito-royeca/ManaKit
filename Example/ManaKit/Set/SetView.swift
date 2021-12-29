//
//  SetView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit
import SDWebImageSwiftUI

struct SetView: View {
    @ObservedObject var viewModel = SetViewModel()
    var setName: String
    
    init(setName: String, setCode: String, languageCode: String) {
        self.setName = setName
        viewModel.setCode = setCode
        viewModel.languageCode = languageCode
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { (geometry) in
                List {
                    ForEach(viewModel.cards) { card in
                        let cardView = CardView(newId: card.newId ?? "")
                        NavigationLink(destination: cardView) {
                            SetRowView(card: card)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(setName)
            
            ActivityIndicatorView(shouldAnimate: $viewModel.isBusy)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SetView(setName: "Alliances", setCode: "all", languageCode: "en")
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}

struct SetRowView: View {
    private let card: MGCard
    private var nameFont: Font
    
    init(card: MGCard) {
        self.card = card
        
        let font = card.nameFont()
        nameFont = Font.custom(font.name, size: font.size)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                WebImage(url: card.imageURL(for: .artCrop))
                .resizable()
    //            .placeholder(Image("cropback-hq", bundle: .main))
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                
                if !card.displayPowerToughness.isEmpty {
                    Text(card.displayPowerToughness)
                        .font(.footnote)
                        .frame(maxWidth: 30, maxHeight: 30)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                }
            }
            
            VStack(alignment: .leading) {
                Text(card.displayName)
                    .font(nameFont)
                HStack {
                    Text(card.displayTypeLine)
                        .font(.footnote)
                    Spacer()
                    Text(card.displayKeyrune)
                        .scaledToFit()
                        .font(Font.custom("Keyrune", size: 30))
                        .foregroundColor(Color(card.keyruneColor()))
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

