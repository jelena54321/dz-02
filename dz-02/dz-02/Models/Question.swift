//
//  Question.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

class Question: Decodable {
    
    /// Question id.
    let id: Int
    /// Question content.
    let question: String
    /// List of answers.
    let answers: [String]
    /// Correct answer.
    let correctAnswer: Int
    
    /// Coding keys.
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }
}
