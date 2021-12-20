//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import PromiseKit
//import PMKFoundation

extension ManaKit {
    public func createNodePromise(apiPath: String, httpMethod: String, httpBody: String?) -> Promise<(data: Data, response: URLResponse)> {
        let urlString = "\(apiURL)\(apiPath)"
        
        guard let cleanURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: cleanURL) else {
            fatalError("Malformed url")
        }
        
        var rq = URLRequest(url: url)
        rq.httpMethod = httpMethod.uppercased()
        rq.setValue("application/json", forHTTPHeaderField: "Accept")
        if let httpBody = httpBody {
            rq.httpBody = httpBody.replacingOccurrences(of: "\n", with: "").data(using: .utf8)
        }
    
        return URLSession.shared.dataTask(.promise, with: rq)
    }
    
}
