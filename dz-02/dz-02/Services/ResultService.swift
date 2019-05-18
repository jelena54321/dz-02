//
//  ResultService.swift
//  dz-02
//
//  Created by Jelena Šarić on 18/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Enum which presents *HTTP* answer.
enum HttpAnswer: Int {
    
    /// Token does not exist.
    case UNAUTHORIZED = 401
    /// Provided token is not corresponding to given user.
    case FORBIDDEN = 403
    /// Quiz with provided quiz id does not exist.
    case NOT_FOUND = 404
    /// Sent request is of illegal format.
    case BAD_REQUEST = 400
    /// Success.
    case OK = 200
}

/// Class which provides posting quiz results on server.
class ResultService {
    
    /// Default *string* representation of *URL* source.
    private static let stringUrl: String = "https://iosquiz.herokuapp.com/api/result"
    
    /**
     Posts quiz results on server with *URL* address represented with default *stringUrl*.
     
     - Parameters:
        - quizId: id for which quiz results are being posted
        - time: total quiz solving time
        - noOfCorrect: number of correctly answered questions
        - onComplete: action which will be executed once post is finished
    */
    func postQuizResults(quizId: Int, time: Double, noOfCorrect: Int, onComplete: @escaping ((HttpAnswer?) -> Void)) {
        
        if let url = URL(string: ResultService.stringUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.setValue(
                UserDefaults.standard.string(forKey: "token"),
                forHTTPHeaderField: "Authorization"
            )
            
            let data: [String: Any] = [
                "quiz_id": quizId,
                "user_id": UserDefaults.standard.integer(forKey: "userId"),
                "time": time,
                "no_of_correct": noOfCorrect
            ]
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: data,
                options: []
            )
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    onComplete(HttpAnswer(rawValue: httpResponse.statusCode))
                } else {
                    onComplete(nil)
                }
            }
            
            dataTask.resume()
            
        } else {
            onComplete(nil)
        }
    }
}
