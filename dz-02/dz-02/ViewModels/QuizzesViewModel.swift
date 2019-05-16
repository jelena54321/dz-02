//
//  QuizzesViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Structure which is used for filling **QuizTableViewCell* with data.
struct QuizViewModel {
    
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
    
    init(quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category
        self.level = quiz.level
        self.image = quiz.image
        self.questions = quiz.questions
    }
}

/**
 Class which presents communication between **QuizzesViewController** and
 model.
 */
class QuizzesViewModel {
    
    /// Quizzes array.
    var quizzes: [Quiz]?
    
    /**
     Fetches quizzes from server.
     
     - Parameters:
        - onComplete: action which will be executed once fetching is complete
    */
    func fetchQuizzes(onComplete: @escaping (() -> Void)) {
        QuizService().fetchQuizzes { [weak self] (quizzes) in
            self?.quizzes = quizzes
            onComplete()
        }
    }
    
    func viewModel(atIndex index: Int) {
        
    }
    
    /**
     Returns **QuizViewModel** structure which corresponds **Quiz** object
     at index specified with argument.
     
     - Parameters:
        - atIndex: at which index is quiz inquired
     
     - Returns: structure corresponding to internally stored **Quiz** object
     at specified position
     */
    func quiz(atIndex index: Int) -> QuizViewModel? {
        guard let quizzes = self.quizzes else {
            return nil
        }
        
        return QuizViewModel(quiz: quizzes[index])
    }
    
    /// Returns number of quizzes stored at internal container.
    func numberOfQuizzes() -> Int {
        return quizzes?.count ?? 0
    }
    
}
