//
//  SetView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit

struct SetView: View {
    @ObservedObject var viewModel = SetViewModel()
    
    init(set: MGSet, languageCode: String) {
        viewModel.set = set
        viewModel.languageCode = languageCode
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                List {
                    ForEach(viewModel.set?.cards?.allObjects as? [MGCard] ?? [MGCard]()) { card in
                        SetRowView(card: card)
                    }
                }
                ActivityIndicatorView(shouldAnimate: $viewModel.isBusy)
            }
            .navigationBarTitle(viewModel.set?.name ?? "Set name", displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.fetchData()
        }
    }
    
    
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        let set = MGSet()
        set.name = "Ice Age"
        let view = SetView(set: set, languageCode: "en")
        
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
            Text(card.name ?? "Card name")
        }
    }
}
