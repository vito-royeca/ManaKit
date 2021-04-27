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
//            List(viewModel.sets, id: \.self) {
//                SetsRowView(set: $0)
//            }
            Text("Sets")
            .navigationBarTitle("Sets")
            .onAppear {
                self.viewModel.fetchRemoteData()
            }
        }
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView()
    }
}
