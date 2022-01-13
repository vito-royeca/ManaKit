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
        List {
            ForEach(viewModel.sets) { set in
                let setView = SetView(setCode: set.code ?? "", languageCode: "en")
                NavigationLink(destination: setView) {
                        SetsRowView(set: set)
                }
            }
        }
            .listStyle(.plain)
            .navigationBarTitle("Sets")
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
            .onAppear {
                viewModel.fetchData()
            }
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SetsView()
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}

struct SetsRowView: View {
    private let set: MSet
    
    init(set: MSet) {
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


