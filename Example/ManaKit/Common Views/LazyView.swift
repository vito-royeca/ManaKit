//
//  LazyView.swift
//  ManaKit
//
//  Created by Vito Royeca on 3/17/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

