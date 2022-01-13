//
//  RulesView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        Text("Rules")
            .navigationBarTitle("Rules", displayMode: .automatic)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
    //                self.viewModel.fetchRemoteData()
            }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
