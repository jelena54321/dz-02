//
//  QuizService.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides acquiring **Quiz** array from server.
class QuizService {
    
    /// Default *string* representation of *URL* source.
    private static let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
    
    /**
     Fetches **Quiz** array in *json* format.
     
     - Parameters:
        - onComplete: action which will be executed once fetch is finished
     */
    func fetchQuizzes(onComplete: @escaping (([[Quiz]]?) -> Void)) {
        if let url = URL(string: QuizService.urlString) {
            
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data,
                            options: []
                        )
                        
                        onComplete(QuizService.parseQuizzes(json: json))
                    } catch {
                        onComplete(nil)
                    }
                    
                } else {
                    onComplete(nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil)
        }
    }
    
    /**
     Parses provided *json* object into array of **Quiz** arrays where all
     **Quiz** objects are grouped by quiz category.
     
     - Parameters:
        - json: *json* object which represents quizzes
     
     - Returns: a new array of **Quiz** arrays if provided data can be interpreted as
     such, otherwise *nil*.
     */
    static func parseQuizzes(json: Any) -> [[Quiz]]? {
        if let jsonDictionary = json as? [String: Any],
           let quizzes = jsonDictionary["quizzes"] as? [Any] {
            
            var quizArray = [Quiz]()
            for quiz in quizzes {
                if let quiz = quiz as? [String: Any],
                   let dataQuiz = try? JSONSerialization.data(withJSONObject: quiz, options: []),
                   let decodedQuiz = try? JSONDecoder().decode(Quiz.self, from: dataQuiz) {
                    
                    quizArray.append(decodedQuiz)
                }
            }
            
            return QuizService.groupQuizzesByCategory(quizzes: quizArray)
        }
        
        return nil
    }
    
    /**
     Groups provided **Quiz** array into array of **Quiz** arrays where all
     **Quiz** objects in same array share same quiz category.
     
     - Parameters:
        - quizzes: **Quiz** array which whill be grouped
     
     - Returns: a new array of **Quiz** arrays grouped by quiz category.
    */
    private static func groupQuizzesByCategory(quizzes: [Quiz]) -> [[Quiz]] {
        let categoryDictionary = Dictionary.init(
            grouping: quizzes)
            { (quiz) -> Category in
                quiz.category
            }
        return Array(categoryDictionary.values)
    }
    
}
