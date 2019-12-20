//
//  ServerInfoViewModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import CoreData
import PromiseKit

public class ServerInfoViewModel: BaseViewModel {
    override public init() {
        super.init()
        
        entityName = String(describing: MGServerInfo.self)
        sortDescriptors = [NSSortDescriptor(key: "scryfallVersion", ascending: true)]
    }

    // MARK: Overrides
    override public func composeFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
        return MGServerInfo.fetchRequest()
    }
    
    override public func fetchRemoteData() -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(ManaKit.Constants.APIURL)/serverinfo"
        
        return ManaKit.sharedInstance.createNodePromise(urlString: urlString,
                                                        httpMethod: "GET",
                                                        httpBody: nil)
    }
}
