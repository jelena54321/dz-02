//
//  QuizViewController.swift
//  dz-02
//
//  Created by Jelena Šarić on 17/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

/// Class which presents single quiz view controller.
class QuizViewController: UIViewController {
    
    /// Quiz title view.
    @IBOutlet weak var quizTitleLabel: UILabel!
    /// Quiz image view.
    @IBOutlet weak var quizImageView: UIImageView!
    /// Start quiz button.
    @IBOutlet weak var quizStartButton: UIButton!
    /// Scroll view containing quiz questions.
    @IBOutlet weak var scrollView: UIScrollView!
    /// Question views.
    var questionViews: [QuestionView]!
    
    /// View model.
    var quizViewModel: QuizViewModel!
    /// Quiz start time.
    var quizStartTime: Date?
    /// Correct answers counter.
    var correctAnswersCounter: Int = 0
    
    /**
     Initializes **QuizViewController** with *viewModel* provided as
     argument.
     
     - Parameters:
        - quizViewModel: **QuizViewModel** object reference used for communication
     with model
     
     - Returns: initialized **QuizViewController** object
    */
    convenience init(quizViewModel: QuizViewModel) {
        self.init()
        self.quizViewModel = quizViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
        bindViewModel()
    }
    
    /// Defines action which will be executed once *Start Quiz* button is tapped.
    @IBAction func startQuizTapped() {
        quizStartButton.isHidden = true
        scrollView.isHidden = false
        quizStartTime = Date()
    }
    
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        navigationController?.navigationBar.isTranslucent = false
        let defaultFont = UIFont.init(name: "Avenir-Book", size: 25.0)
        
        quizTitleLabel.font = defaultFont
        quizTitleLabel.textAlignment = .center
        quizTitleLabel.adjustsFontSizeToFitWidth = true
    
        quizTitleLabel.autoPinEdge(.top, to: .top, of: self.view, withOffset: 10.0)
        quizTitleLabel.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40.0)
        quizTitleLabel.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40.0)
        quizTitleLabel.autoSetDimension(.height, toSize: 40.0)
        
        quizImageView.autoPinEdge(.top, to: .bottom, of: quizTitleLabel, withOffset: 20.0)
        quizImageView.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        quizImageView.autoSetDimension(.width, toSize: 100.0)
        quizImageView.autoSetDimension(.height, toSize: 100.0)
        
        quizStartButton.titleLabel?.font = defaultFont
        quizStartButton.setTitle("Start Quiz", for: .normal)
        quizStartButton.setTitleColor(UIColor.white, for: .normal)
        quizStartButton.layer.cornerRadius = 5.0
        quizStartButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        
        quizStartButton.autoPinEdge(.top, to: .bottom, of: quizImageView, withOffset: 20.0)
        quizStartButton.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40.0)
        quizStartButton.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40.0)
        quizStartButton.autoSetDimension(.height, toSize: 40.0)
        
        setUpScrollView()
    }
    
    /// Sets up scroll view with quiz questions.
    private func setUpScrollView() {
        scrollView.isHidden = true
        scrollView.isScrollEnabled = false
        
        scrollView.autoPinEdge(.leading, to: .leading, of: self.view)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: self.view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: self.view)
        scrollView.autoPinEdge(.top, to: .bottom, of: quizStartButton, withOffset: 30.0)
    
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.height, to: .height, of: scrollView)
        
        questionViews = [QuestionView]()
        let questions = Array(quizViewModel.quizQuestions.values)
        var leftView = contentView
        for i in 0..<questions.count {
            let questionView = QuestionView(questionViewModel: QuestionViewModel(question: questions[i]))
            contentView.addSubview(questionView)
            questionViews.append(questionView)
            questionView.delegate = self
            
            questionView.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
            questionView.autoSetDimension(.width, toSize: 300.0)
            
            if i == 0 {
                questionView.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 30.0)
            } else {
                questionView.autoPinEdge(.leading, to: .trailing, of: leftView, withOffset: 30.0)
            }
            
            if i == questions.count - 1 {
                questionView.autoPinEdge(.trailing, to: .trailing, of: contentView)
            }
            
            leftView = questionView
        }
    }
    
    /// Binds view model to graphic user interface.
    private func bindViewModel() {
        quizTitleLabel.text = quizViewModel.quizTitle
        quizImageView.kf.setImage(with: quizViewModel.quizImageURL)
    }
}

extension QuizViewController: QuestionViewDelegate {
    
    func questionAnswered(questionView: QuestionView, isCorrect: Bool) {
        guard let questionViewIndex = getQuestionViewIndex(questionView: questionView) else {
            return
        }
        
        if isCorrect {
            correctAnswersCounter += 1
        }
        if questionViewIndex == questionViews.count - 1 {
            evaluateQuiz()
        } else {
            scrollView.setContentOffset(
                CGPoint(x: Double((questionViewIndex + 1) * 330), y: 0.0),
                animated: true
            )
        }
    }
    
    /**
     Gets **QuestionView** object index.
     
     - Parameters:
        - questionView: **QuestionView** object which index is inquired
     
     - Returns: index of a provided **QuestionView** object
    */
    private func getQuestionViewIndex(questionView: QuestionView) -> Int? {
        for i in 0..<questionViews.count {
            if questionView == questionViews[i] {
                return i
            }
        }
        
        return nil
    }
    
    /// Evaluates quiz.
    private func evaluateQuiz() {
        let quizEndTime = Date()
        if let quizStartTime = quizStartTime,
           let quizId = quizViewModel.quizId {
            let totalQuizTime = quizEndTime.timeIntervalSince1970 - quizStartTime.timeIntervalSince1970
            let noOfCorrect = self.correctAnswersCounter
            
            ResultService().postQuizResults(
                quizId: quizId,
                time: totalQuizTime,
                noOfCorrect: noOfCorrect)
                { [weak self] (httpAnswer) in
                    if let httpAnswer = httpAnswer {
                        if httpAnswer == HttpAnswer.OK {
                            DispatchQueue.main.async {
                                self?.navigationController?.popViewController(animated: true)
                            }
                            
                        } else {
                            self?.alertUser(
                                quizId: quizId,
                                time: totalQuizTime,
                                noOfCorrect: noOfCorrect
                            )
                        }
                    }
                }
        }
    }
    
    /**
     Alerts user by showing alert to graphic user interface.
     
     - Parameters:
        - quizId: quiz id
        - time: total quiz time
        - noOfCorrect: number of correctly answered questions
    */
    private func alertUser(quizId: Int, time: Double, noOfCorrect: Int) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Unsuccessful quiz post",
                message: "Something went wrong while trying to post quiz results",
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "Send Again",
                    style: .default)
                    { (action) in
                        ResultService().postQuizResults(
                            quizId: quizId,
                            time: time,
                            noOfCorrect: noOfCorrect)
                            { [weak self] (httpAnswer) in
                                if let httpAnswer = httpAnswer {
                                    if httpAnswer == HttpAnswer.OK {
                                        DispatchQueue.main.async {
                                            self?.navigationController?.popViewController(animated: true)
                                        }
                                        
                                    }
                                }
                            }
                    }
            )
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
