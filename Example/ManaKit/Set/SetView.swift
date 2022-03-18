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
    @StateObject var viewModel = SetViewModel()
    var setCode: String
    var languageCode: String
    
    init(setCode: String, languageCode: String) {
        self.setCode = setCode
        self.languageCode = languageCode
        
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        List {
            ForEach(viewModel.cards) { card in
                let cardView = CardView(newID: card.newID)
                let lazyView = LazyView(cardView)
                CardRowView(card: card)
                    .background(NavigationLink("", destination: lazyView).opacity(0))
                    .listRowSeparator(.hidden)
            }
        }
            .listStyle(.plain)
            .navigationBarTitle(viewModel.isBusy ? "Loading..." : viewModel.set?.name ?? "")
            .overlay(
                Group {
                    if viewModel.isBusy {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        EmptyView()
                    }
                })
            .onAppear {
                viewModel.setCode = setCode
                viewModel.languageCode = languageCode
                viewModel.fetchData()
            }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SetView(setCode: "all", languageCode: "en")
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}


