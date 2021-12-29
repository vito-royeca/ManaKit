//
//  CardView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit
import SDWebImageSwiftUI

struct CardView: View {
    @ObservedObject var viewModel = CardViewModel()
    var newId: String
    
    init(newId: String) {
        self.newId = newId
        viewModel.newId = newId
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                List {
                    WebImage(url: viewModel.card?.imageURL(for: .normal))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: geometry.size.width/2, height: geometry.size.height/2, alignment: .center)
                    
                    Group {
                        CardTextRowView(title: viewModel.card?.displayName ?? "", subtitle: "Name")
                        CardTextRowView(title: viewModel.card?.displayTypeLine ?? "", subtitle: "Type")
                        
                        CardTextRowView(title: viewModel.card?.set?.name ?? "", subtitle: "Set")
                        
                        HStack {
                            Text("Set Symbol")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.card?.displayKeyrune ?? "")
                                .scaledToFit()
                                .font(Font.custom("Keyrune", size: 30))
                                                    .foregroundColor(Color(viewModel.card?.keyruneColor() ?? .black))
                        }
                        
                        CardTextRowView(title: viewModel.card?.rarity?.name ?? "", subtitle: "Rarity")
                        CardTextRowView(title: viewModel.card?.displayPowerToughness ?? "", subtitle: "Power/Toughness")
                        CardTextRowView(title: viewModel.card?.artist?.name ?? "", subtitle: "Artist")
                        CardTextRowView(title: viewModel.colors.map { $0.name ?? ""}.description, subtitle: "Colors")
                        CardTextRowView(title: viewModel.colorIdentities.map { $0.name ?? ""}.description, subtitle: "Color Identities")
                        CardTextRowView(title: viewModel.colorIndicators.map { $0.name ?? ""}.description, subtitle: "Color Indicators")
                    }
                    Group {
                        CardTextRowView(title: viewModel.faces.map { $0.displayName}.description, subtitle: "Faces")
                        CardTextRowView(title: viewModel.card?.frame?.name ?? "", subtitle: "Frame")
                        CardTextRowView(title: viewModel.card?.frameEffect?.name ?? "", subtitle: "Frame Effect")
                        CardTextRowView(title: viewModel.card?.language?.name ?? "", subtitle: "Language")
                        CardTextRowView(title: viewModel.card?.layout?.name ?? "", subtitle: "Layout")
                        CardTextRowView(title: viewModel.otherLanguages.map { $0.name ?? ""}.description, subtitle: "Other Languages")
                        HStack {
                            Text("Other Printings")
                                .font(.headline)
                            Spacer()
                            HStack {
                                ForEach (viewModel.otherPrintings) { otherPrinting in
                                    Text(otherPrinting.displayKeyrune)
                                        .scaledToFit()
                                        .font(Font.custom("Keyrune", size: 30))
                                        .foregroundColor(Color(otherPrinting.keyruneColor()))
                                }
                            }
                        }
                        CardTextRowView(title: viewModel.subtypes.map { $0.name ?? ""}.description, subtitle: "Subtypes")
                        CardTextRowView(title: viewModel.supertypes.map { $0.name ?? ""}.description, subtitle: "Supertypes")
                        CardTextRowView(title: viewModel.variations.map { $0.displayName}.description, subtitle: "Variations")
                    }
                }
                .listStyle(.plain)
                .navigationBarTitle(viewModel.card?.displayName ?? "")
                
                ActivityIndicatorView(shouldAnimate: $viewModel.isBusy)
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let view = CardView(newId: "all_en_116a")
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}

struct CardTextRowView: View {
    var title: String
    var subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            Text(subtitle)
                .font(.headline)
            Spacer()
            Text(title)
                .font(.subheadline)
        }
    }
}
