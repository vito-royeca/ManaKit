//
//  ManaKit+API.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

import Foundation
import PromiseKit

extension ManaKit {
    public func createNodePromise(urlString: String, httpMethod: String, httpBody: String?) -> Promise<(data: Data, response: URLResponse)> {
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
