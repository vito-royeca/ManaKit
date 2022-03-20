//
//  SearchView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 1/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State var query: String?
    @State var scopeSelection: Int = 0
    
    init() {
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        SearchNavigation(query: $query,
                         scopeSelection: $scopeSelection,
                         isBusy: $viewModel.isBusy,
                         delegate: self) {
            List {
                ForEach(viewModel.cards) { card in
                    let cardView = CardView(newID: card.newID)
//                    let lazyView = LazyView(cardView)
                    CardRowView(card: card)
                        .background(NavigationLink("", destination: cardView).opacity(0))
                        .listRowSeparator(.hidden)
                }
            }
                .listStyle(.plain)
                .navigationBarTitle("Search")
                .overlay(
                    Group {
                        if viewModel.isBusy {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        else {
                            EmptyView()
                        }
                    })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SearchView()
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}

// MARK: - SearchNavigation

extension SearchView: SearchNavigationDelegate {
    var options: [SearchNavigationOptionKey : Any]? {
        return [
            .automaticallyShowsSearchBar: true,
            .obscuresBackgroundDuringPresentation: true,
            .hidesNavigationBarDuringPresentation: true,
            .hidesSearchBarWhenScrolling: false,
            .placeholder: "Search",
            .showsBookmarkButton: false,
//            .scopeButtonTitles: ["All", "Bookmarked", "Seen"],
//            .scopeBarButtonTitleTextAttributes: [NSAttributedString.Key.font: UIFont.dckxRegularText],
//            .searchTextFieldFont: UIFont.dckxRegularText
         ]
    }
    
    func search() {
        guard let query = query,
            query.count >= 3 else {
            return
        }
        
        viewModel.fetchData(query: query)
    }
    
    func scope() {
        
    }
    
    func cancel() {
        query =  nil
    }
}


