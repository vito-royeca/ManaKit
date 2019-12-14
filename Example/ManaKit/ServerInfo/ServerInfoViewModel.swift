//
//  ServerInfoViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import CoreData
import ManaKit
import PromiseKit

class ServerInfoViewModel: BaseViewModel {
    override init() {
        super.init()
        
        entityName = String(describing: ServerInfo.self)
        sortDescriptors = [NSSortDescriptor(key: "scryfallVersion", ascending: true)]
    }

    // MARK: Overrides
    override func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return ServerInfo.fetchRequest()
    }
    
    override func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/serverinfo"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
