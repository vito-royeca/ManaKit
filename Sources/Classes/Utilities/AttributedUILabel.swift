//
//  AttributedUILabel.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/28/21.
//

import SwiftUI

public struct AttributedUILabel: UIViewRepresentable {

    fileprivate var configuration = { (view: UILabel) in }

    public init() {}
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        UILabel()
    }
    
    public func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}
