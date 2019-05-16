//
//  Quiz.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which presents quiz.
class Quiz: Decodable {
    
    /// Quiz id.
    let id: Int
    /// Quiz title.
    let title: String
    /// Quiz description.
    let description: String
    /// Quiz category.
    let category: Category
    /// Quiz level.
    let level: Int
    /// Quiz image.
    let image: String
    /// Dictionary of quiz questions.
    let questions: [Int: Question]
    
    /// Coding keys.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case image
        case questions
    }
    
    /**
     Initializes a new **Quiz** object using provided *decoder* object.
     
     - Parameters:
        - decoder: **Decoder** object which represents decoder
     
     - Returns: a new **Quiz** object
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        level = try container.decode(Int.self, forKey: .level)
        image = try container.decode(String.self, forKey: .image)
        
        var questions = [Int: Question]()
        var questionsArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.questions)
        while (!questionsArray.isAtEnd) {
            let question = try questionsArray.decode(Question.self)
            questions[question.id] = question
        }
        self.questions = questions
    }
    
}
