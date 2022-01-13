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
                    HStack {
                        Text("Mana Cost")
                            .font(.headline)
                        Spacer()
                        AttributedText(
                            NSAttributedString(symbol: viewModel.card?.manaCost ?? "", pointSize: 16)
                        )
                            .multilineTextAlignment(.trailing)
                    }
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
                    VStack(alignment: .center) {
                        Text("Oracle Text")
                            .font(.headline)
                        Spacer()
                        AttributedText(
                            NSAttributedString(symbol: viewModel.card?.oracleText ?? "", pointSize: 16)
                        )
                            .font(.body)
                    }
                    VStack(alignment: .center) {
                        Text("Printed Text")
                            .font(.headline)
                        Spacer()
                        AttributedText(
                            NSAttributedString(symbol: viewModel.card?.printedText ?? "", pointSize: 16)
                        )
                            .font(.body)
                    }
                    CardTextRowView(title: viewModel.card?.displayFlavorText ?? "", subtitle: "Flavor Text", style: .vertical)
                    CardTextRowView(title: viewModel.card?.displayPowerToughness ?? "", subtitle: "Power/Toughness")
                    
                }
                Group {
                    CardTextRowView(title: viewModel.card?.loyalty ?? "", subtitle: "Loyalty")
                    CardTextRowView(title: viewModel.card?.artist?.name ?? "", subtitle: "Artist")
                    CardTextRowView(title: "#\(viewModel.card?.collectorNumber ?? "")", subtitle: "Collector Number")
                    CardTextRowView(title: (viewModel.card?.colors ?? []).map { $0.name ?? ""}.description, subtitle: "Colors")
                    CardTextRowView(title: (viewModel.card?.colorIdentities ?? []).map { $0.name ?? ""}.description, subtitle: "Color Identities")
                    CardTextRowView(title: (viewModel.card?.colorIndicators ?? []).map { $0.name ?? ""}.description, subtitle: "Color Indicators")
                    CardTextRowView(title: (viewModel.card?.cmc ?? 0) == 0 ? "" : "\(viewModel.card?.cmc ?? 0)", subtitle: "Converted Mana Cost")
                    CardTextRowView(title: (viewModel.card?.faces ?? []).map { $0.displayName }.description, subtitle: "Faces")
                    CardTextRowView(title: viewModel.card?.frame?.name ?? "", subtitle: "Frame")
                    CardTextRowView(title: (viewModel.card?.frameEffects ?? []).map { $0.name ?? ""}.description, subtitle: "Frame Effects")
                }
                Group {
                    CardTextRowView(title: viewModel.card?.language?.name ?? "", subtitle: "Language")
                    CardTextRowView(title: viewModel.card?.layout?.name ?? "", subtitle: "Layout")
                    CardTextRowView(title: (viewModel.card?.otherLanguages ?? []).map { $0.name ?? ""}.description, subtitle: "Other Languages")
                    HStack {
                        Text("Other Printings")
                            .font(.headline)
                        Spacer()
                        HStack {
                            ForEach (viewModel.card?.otherPrintings ?? []) { otherPrinting in
                                Text(otherPrinting.displayKeyrune)
                                    .scaledToFit()
                                    .font(Font.custom("Keyrune", size: 30))
                                    .foregroundColor(Color(otherPrinting.keyruneColor()))
                            }
                        }
                    }
                    CardTextRowView(title: (viewModel.card?.subtypes ?? []).map { $0.name ?? ""}.description, subtitle: "Subtypes")
                    CardTextRowView(title: (viewModel.card?.supertypes ?? []).map { $0.name ?? ""}.description, subtitle: "Supertypes")
                    CardTextRowView(title: (viewModel.card?.variations ?? []).map { "\($0.collectorNumber ?? "")" }.description, subtitle: "Variations")
                    CardTextRowView(title: viewModel.card?.watermark?.name ?? "", subtitle: "Watermark")
                }
            }
                .listStyle(.plain)
                .navigationBarTitle(viewModel.card?.displayName ?? "Card name")
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
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let view = CardView(newId: "all_en_116a")
        view.viewModel.dataAPI = MockAPI()
        
        return view
    }
}

enum CardTextRowViewStyle {
    case horizontal, vertical
}

struct CardTextRowView: View {
    
    
    var title: String
    var subtitle: String
    var style: CardTextRowViewStyle
    
    init(title: String, subtitle: String, style: CardTextRowViewStyle = .horizontal) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }
    
    var body: some View {
        switch style {
        case .horizontal:
            HStack {
                Text(subtitle)
                    .font(.headline)
                Spacer()
                Text(title)
                    .font(.subheadline)
            }
        case .vertical:
            VStack(alignment: .center) {
                Text(subtitle)
                    .font(.headline)
                Spacer()
                Text(title)
                    .font(.subheadline)
            }
        }
    }
}
