//
//  Logger.swift
//  HealthTracker-ios
//
//  Created by sergey on 20.11.2024.
//

import Foundation

struct Logger {
    func log(apiRequest: API.Request, request: URLRequest, response: URLResponse, data: Data) {
        let httpResponse = response as? HTTPURLResponse
        let authorizationHeader = request.value(forHTTPHeaderField: "Authorization")
        
        let httpMethod = apiRequest.method.rawValue
        let url = apiRequest.url
        let body = apiRequest.body
        let multipart = apiRequest.formData
        let usesAcessToken = apiRequest.usesAccessToken
        
        let statusCode = httpResponse?.statusCode.description
        
        let jsonString = String(data: data, encoding: .utf8)
        
        let output: String = {
            var output = "\(httpMethod) \(url.absoluteString)"
            output += "\nStatus Code: \(statusCode ?? "-")"
            
            let separatorLength: Int = output.count
            
            output += "\nUses Access Token: \(usesAcessToken)"
            
            if let authorizationHeader {
                output += "\nAuthorization: \(authorizationHeader)"
            }
            
            output += "\nBody: \(body.description)"
            
            if let multipart {
                output += "\nMultipart: \(multipart.debugDescription)"
            }
            
            output += "\nResponse: \(jsonString ?? String(reflecting: data))\n"
            
            output += String(repeating: "-", count: separatorLength)
            
            return output
        }()
        
        
        print(output)
    }
}
