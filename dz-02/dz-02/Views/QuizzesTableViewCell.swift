//
//  QuizzesTableViewCell.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import Kingfisher

/// Class which presents single **UITableViewCell** in **UITableView**.
class QuizzesTableViewCell: UITableViewCell {
    
    /// Quiz image view.
    @IBOutlet weak var quizImageView: UIImageView!
    /// Fields container.
    @IBOutlet weak var fieldsContainer: UIView!
    /// Label containing quiz title.
    @IBOutlet weak var quizTitleLabel: UILabel!
    /// Label containing quiz description.
    @IBOutlet weak var quizDescriptionLabel: UILabel!
    /// Custom view container.
    @IBOutlet weak var customViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        quizImageView.autoSetDimension(.width, toSize: 100.0)
        quizImageView.autoSetDimension(.height, toSize: 100.0)
        quizImageView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        quizImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 10.0)
        
        fieldsContainer.autoAlignAxis(.horizontal, toSameAxisOf: self)
        fieldsContainer.autoSetDimension(.height, toSize: 80.0)
        fieldsContainer.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 10.0)
        fieldsContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10.0)
        
        quizTitleLabel.numberOfLines = 1
        quizTitleLabel.font = UIFont(name: "Avenir-Book", size: 16.0)
        quizTitleLabel.adjustsFontSizeToFitWidth = true
        quizTitleLabel.autoPinEdge(.top, to: .top, of: fieldsContainer)
        quizTitleLabel.autoPinEdge(.leading, to: .leading, of: fieldsContainer)
        quizTitleLabel.autoPinEdge(.trailing, to: .trailing, of: fieldsContainer)
        quizTitleLabel.autoSetDimension(.height, toSize: 25.0)
        
        quizDescriptionLabel.numberOfLines = 0
        quizDescriptionLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        quizDescriptionLabel.textColor = UIColor.darkGray
        quizDescriptionLabel.autoPinEdge(.bottom, to: .bottom, of: fieldsContainer)
        quizDescriptionLabel.autoPinEdge(.leading, to: .leading, of: fieldsContainer)
        quizDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: fieldsContainer)
        quizDescriptionLabel.autoSetDimension(.height, toSize: 50.0)
        
        customViewContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10.0)
        customViewContainer.autoPinEdge(.top, to: .top, of: self, withOffset: 10.0)
        customViewContainer.autoSetDimension(.height, toSize: 40.0)
        customViewContainer.autoSetDimension(.width, toSize: 140.0)
        
        let levelIconsView = QuizLevelView(
            frame: CGRect(
                origin: CGPoint(x: 0.0, y: 0.0),
                size: CGSize(width: 140.0, height: 40.0)
            )
        )
        customViewContainer.addSubview(levelIconsView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        quizImageView.image = nil
        quizTitleLabel.text = ""
        quizDescriptionLabel.text = ""
        if let levelView = customViewContainer.subviews.first as? QuizLevelView {
            levelView.level = 0
        }
    }
    
    /**
     Fills cell with data from provided **quizViewModel** structure.
     
     - Parameters:
     - quiz: structure which presents quiz with data which will be used for
     filling this cell
     */
    func setUp(withQuiz quiz: QuizViewModel) {
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.text = quiz.description
        if let levelView = customViewContainer.subviews.first as? QuizLevelView {
            levelView.level = quiz.level
        }
        
        if let imageUrl = URL(string: quiz.image) {
            quizImageView.kf.setImage(with: imageUrl)
        }
    }
    
}
