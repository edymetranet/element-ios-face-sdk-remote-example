//
//  NetworkingHelper.swift
//  demo_protected
//
//  Created by Laurent Grandhomme on 12/18/17.
//  Copyright © 2017 Element. All rights reserved.
//

import UIKit

struct NetworkError: Error {
    let errorCode: Int
}

class NetworkingHelper: NSObject {
    class func post(params : Dictionary<String, NSObject>, url : String, apiKey: String, success: @escaping (NSDictionary)->(), onError: @escaping (Error?, String?)->()) {
        let urlObject = String(format: url)
        guard let serviceUrl = URL(string: urlObject) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            request.addValue(bundleIdentifier, forHTTPHeaderField: "appId")
        }
        
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        request.addValue("1.0", forHTTPHeaderField: "sdkVersion")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            var succeeded = false
            var statusCode = 200
            if let response = response as? HTTPURLResponse {
                statusCode = response.statusCode
                if response.statusCode == 200 {
                    succeeded = true
                }
            }
            if let data = data {
                if 0 == data.count {
                    if succeeded {
                        success([:])
                    } else {
                        onError(NetworkError(errorCode: statusCode), String(format:"Failed with error %i", statusCode))
                    }
                    return
                }
            
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    if succeeded {
                        success(json)
                    } else {
                        if let msg = json["message"] as? String {
                            onError(nil, msg)
                        } else {
                            onError(nil, "http error code: " + String(statusCode))
                        }
                    }
                } catch {
                    onError(error, nil)
                }
            } else {
                onError(nil, nil)
            }
        }.resume()
    }
}
