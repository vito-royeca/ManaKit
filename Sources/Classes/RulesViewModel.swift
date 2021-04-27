//
//  RulesViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/20/20.
//

import Foundation

class RulesViewModel: ObservableObject {
    private let url = "\(ManaKit.sharedInstance.apiURL)/rules"
//    private var task: AnyCancellable?
    
    @Published var rules: [MGRule] = []
    
    func fetch() {
//        task = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
//            .map { $0.data }
//            .decode(type: [MGRule].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .eraseToAnyPublisher()
//            .receive(on: RunLoop.main)
//            .assign(to: \RulesViewModel.rules, on: self)
    }
}
