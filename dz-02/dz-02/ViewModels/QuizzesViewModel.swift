//
//  QuizzesViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Structure which is used for filling **QuizTableViewCell* with data.
struct QuizCellViewModel {
    
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
 Class which enables communication between model and view controllers.
 This specific class presents quizzes.
 */
class QuizzesViewModel {
    
    /// Quizzes arrays.
    private var quizzes: [[Quiz]]?
    
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
    
    /**
     Returns **QuizViewModel** object corresponding **Quiz** object at index path
     provided with arguent.
     
     - Parameters:
        - indexPath: for which index path is corresponding **SingleQuizViewModel** object
     inquired
     
     - Returns: quiz view model presenting quiz at provided index path.
    */
    func quizViewModel(atIndex indexPath: IndexPath) -> QuizViewModel? {
        guard let quizzes = quizzes else {
            return nil
        }
        
        return QuizViewModel(quiz: quizzes[indexPath.section][indexPath.row])
    }
    
    /**
     Returns **QuizCellViewModel** structure which corresponds **Quiz** object
     at index path specified with argument.
     
     - Parameters:
        - atIndexPath: at which index path is quiz inquired
     
     - Returns: structure corresponding to internally stored **Quiz** object
     at specified position
     */
    func quiz(atIndexPath indexPath: IndexPath) -> QuizCellViewModel? {
        guard let quizzes = self.quizzes else {
            return nil
        }
        
        return QuizCellViewModel(quiz: quizzes[indexPath.section][indexPath.row])
    }
    
    /**
     Returns number of quizzes associated with specified section.
     
     - Parameters:
        - atIndex: for which section is number of quizzes inquired
     
     - Returns: number of quizzes for provided category.
    */
    func numberOfQuizzes(inSection section: Int) -> Int {
        return quizzes?[section].count ?? 0
    }
    
    /// Returns number of distinct categories.
    func numberOfCategories() -> Int {
        return quizzes?.count ?? 0
    }
    
    /**
     Returns category of specified section.
     - Parameters:
        - atIndex: for which section is category acquired
     
     - Returns: category for provided section
     */
    func category(atIndex index: Int) -> Category? {
        guard let quizzes = self.quizzes else {
            return nil
        }
        
        return quizzes[index].first?.category
    }
    
}
