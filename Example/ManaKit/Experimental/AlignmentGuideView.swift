//
//  AlignmentGuideView.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct AlignmentGuideView: View {
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                GeometryReader { proxy in
            
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ControlsView().frame(width: 380).layoutPriority(1).background(Color(UIColor.secondarySystemBackground))

                            DisplayView(width: proxy.size.width - 380).frame(maxWidth: proxy.size.width - 380).clipShape(Rectangle())//.border(Color.green, width: 3)
                            
                        }.frame(height: (proxy.size.height - 300))

                        VStack {
                            CodeView().frame(height: 300)
                        }.frame(width: proxy.size.width, alignment: .center).background(Color(UIColor.secondarySystemBackground))

                        
                    }.environmentObject(Model())
                }
            } else {
                VStack(spacing: 30) {
                    Text("I need an iPad to run!")
                    Text("😟").scaleEffect(2)
                }.font(.largeTitle)
            }
        }
    }
}

struct AlignmentGuideView_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentGuideView()
    }
}
