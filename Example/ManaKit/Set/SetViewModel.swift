//
//  SetViewModel.swift
//  ManaKit_Example
//
//  Created by Vito Royeca on 12/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import CoreData
import SwiftUI
import ManaKit

class SetViewModel: ObservableObject {
    @Published var set: MGSet?
    @Published var isBusy = false
    
    var setCode: String
    var languageCode: String
    var dataAPI: API
    var cancellables = Set<AnyCancellable>()
    
    init(setCode: String = "emn", languageCode: String = "en", dataAPI: API = ManaKit.shared) {
        self.setCode = setCode
        self.languageCode = languageCode
        self.dataAPI = dataAPI
    }
    
    deinit {
        for can in cancellables {
            can.cancel()
        }
    }
        
    func fetchData() {
        isBusy.toggle()
        
        dataAPI.fetchSet(code: setCode,
                         languageCode: languageCode,
                         cancellables: &cancellables,
                         completion: { result in
            self.isBusy.toggle()
            
            switch result {
            case .success(let set):
                self.set = set
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
