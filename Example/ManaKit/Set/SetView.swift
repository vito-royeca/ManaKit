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
            List {
                ForEach(viewModel.cards) { card in
                    let webImage = WebImage(url: card.imageURL(for: .normal))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFit()
                    NavigationLink(destination: webImage) {
                        SetRowView(card: card)
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
    
    init(card: MGCard) {
        self.card = card
    }
    
    var body: some View {
        HStack {
            WebImage(url: card.imageURL(for: .artCrop))
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
//            .placeholder(Image("cropback-hq", bundle: .main))
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
            .frame(width: 100, height: 100, alignment: .center)
            Text(card.name ?? "Card name")
        }
    }
}
