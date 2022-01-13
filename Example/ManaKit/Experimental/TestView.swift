//
//  TestView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State private var selection = 0

    var body: some View {
        VStack(alignment: .center) {
            Text("Sliver Queen")
            AttributedText(
                NSAttributedString(symbol: "{W}{U}{B}{R}{G}",
                                   pointSize: 16)
            )
            AttributedText(
                NSAttributedString(symbol: "{2}: Create a 1/1 colorless Sliver creature token.",
                                   pointSize: 16)
            )
                .font(.body)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

