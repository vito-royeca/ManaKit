//
//  SetsView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit

struct SetsView: View {
    @ObservedObject var viewModel = SetsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.sets, id: \.code) { set in
                SetsRowView(set: set)
            }
                .navigationBarTitle("Sets", displayMode: .automatic)
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.viewModel.fetchData()
            }
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetsViewModel(dataManager: MockSetsDataManager())
        
        var view = SetsView()
        view.viewModel = viewModel
        return view
    }
}

struct SetsRowView: View {
    private let set: MGSet
    
    init(set: MGSet) {
        self.set = set
    }
    
    var body: some View {
        HStack {
            Text(set.keyrune2Unicode())
                .scaledToFit()
                .font(Font.custom("Keyrune", size: 30))
            VStack(alignment: .leading) {
                Text(set.name ?? "")
                    .font(.headline)
                HStack {
                    Text("Code: \(set.code ?? "")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    Spacer()
                    Text("\(set.cardCount) card\(set.cardCount > 1 ? "s" : "")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                }
                Text("Release Date: \(set.releaseDate ?? "")")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
    }
}


