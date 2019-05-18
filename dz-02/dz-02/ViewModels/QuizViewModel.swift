//
//  SingleQuizViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 17/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/**
 Class which presents communication between **QuizViewController** and
 model.
 */
class QuizViewModel {
    
    private var quiz: Quiz?
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    /// Quiz id.
    var quizId: Int? {
        return quiz?.id
    }
    
    /// Quiz title.
    var quizTitle: String {
        return quiz?.title ?? ""
    }
    
    /// Quiz description.
    var quizDescription: String {
        return quiz?.description ?? ""
    }
    
    /// Quiz category.
    var quizCategory: Category? {
        return quiz?.category
    }
    
    /// Quiz level.
    var quizLevel: Int? {
        return quiz?.level
    }
    
    /// Quiz image URL.
    var quizImageURL: URL? {
        if let quizImage = quiz?.image {
            return URL(string: quizImage)
        }
        return nil
    }
    
    /// Quiz questions.
    var quizQuestions: [Int: Question] {
        return quiz?.questions ?? [Int: Question]()
    }
}
