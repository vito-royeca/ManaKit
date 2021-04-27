//
//  SetsRowView.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import ManaKit

struct SetsRowView: View {
    private let set: MGSet
    
    init(set: MGSet) {
        self.set = set
    }
    
    var body: some View {
        HStack {
            Text(ManaKit.sharedInstance.keyruneUnicode2String(set: set) ?? "")
                .scaledToFit()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 15) {
                Text(set.name ?? "")
                    .font(.system(size: 18))
                    .foregroundColor(Color.blue)
                Text("\(set.code ?? "") - \(set.setType?.name ?? "")")
                    .font(.system(size: 14))
            }
        }
    }
}

struct SetsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SetsRowView(set: MGSet())
    }
}
