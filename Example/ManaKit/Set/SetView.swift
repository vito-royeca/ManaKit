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
    
    init(setCode: String, languageCode: String) {
        viewModel.setCode = setCode
        viewModel.languageCode = languageCode
        
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        List {
            ForEach(viewModel.cards) { card in
                let cardView = CardView(newID: card.newID)
                CardRowView(card: card)
                    .background(NavigationLink("", destination: cardView).opacity(0))
                    .listRowSeparator(.hidden)
            }
        }
            .listStyle(.plain)
            .navigationBarTitle(viewModel.set?.name ?? "Loading...")
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
                viewModel.fetchData()
            }
//            .onDisappear {
//                viewModel.clearData()
//            }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SetView(setCode: "all", languageCode: "en")
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}


