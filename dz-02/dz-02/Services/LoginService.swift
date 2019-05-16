//
//  LoginService.swift
//  dz-02
//
//  Created by Jelena Šarić on 09/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides session establishment with server.
class LoginService {
    
    /**
     Establishes session with server on provided url source.
     
     - Parameters:
        - urlString: string representation of url source
        - username: username which will be used for session establishment
        - password: password which will be used for session establishment
        - onComplete: action which will be executed once fetch is finished
     */
    func establishSession(urlString: String, username: String, password: String, onComplete: @escaping ((Int?, String?) -> Void)) {
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/x-www-form-urlencoded",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = "username=\(username)&password=\(password)".data(using: .utf8)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: unwrappedData,
                            options: []
                        )
                    
                        if let (userId, token) = LoginService.parseToken(json: json) {
                            onComplete(userId, token)
                        } else {
                            onComplete(nil, nil)
                        }
                        
                    } catch {
                        onComplete(nil, nil)
                    }
                    
                } else {
                    onComplete(nil, nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil, nil)
        }
    }
    
    /**
     Parses provided *json* as integer associated with key *user_id* and string
     associated with key *token*
     
     - Parameters:
        - json: *json* object which represents access token
     
     - Returns: integer and string tuple stored in *json* object if such items exist,
     otherwise *nil*
     
     */
    private static func parseToken(json: Any) -> (Int, String)? {
        if
            let jsonDictionary = json as? [String: Any],
            let userId = jsonDictionary["user_id"] as? Int,
            let token = jsonDictionary["token"] as? String {
            return (userId, token)
        }
    
        return nil
    }
    
}
