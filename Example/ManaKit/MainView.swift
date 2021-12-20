//
//  MainView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 11/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            SetsView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Sets")
                }
            
            RulesView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Rules")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
