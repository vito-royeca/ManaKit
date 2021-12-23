//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import ManaKit

class SetViewModel: ObservableObject {
    @Published var set: MGSet?
    @Published var isBusy = false
    
    var languageCode: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(set: MGSet = MGSet(), languageCode: String = "en", dataAPI: API = ManaKit.shared) {
        self.set = set
        self.languageCode = languageCode
        self.dataAPI = dataAPI
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
    }
        
    func fetchData() {
        guard let set = set,
           let code = set.code else {
            return
        }
        
        isBusy.toggle()
        
        dataAPI.fetchSet(code: code,
                         languageCode: languageCode,
                         cancellables: &cancellables,
                         completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let set):
                self.set = set
//                print(self.set?.cards?.count ?? 0)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
