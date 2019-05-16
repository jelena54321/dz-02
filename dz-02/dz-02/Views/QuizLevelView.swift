//
//  QuizLevelView.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

/// Class which presents quiz level icon.
class QuizLevelView: UIView {
    
    /// Icons which present quiz level.
    var firstIcon: UIImageView!
    var secondIcon: UIImageView!
    var thirdIcon: UIImageView!
    
    /// Quiz level.
    var level: Int? {
        willSet {
            if let level = newValue {
                updateIcons(level: level)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGUI()
    }
    
    convenience init(frame: CGRect, level: Int) {
        if level < 1 || level > 3 {
            fatalError("Level value is out of legal range {0, 1, 2, 3}.")
        }
        self.init(frame: frame)
        updateIcons(level: level)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        guard let image = UIImage(named: "icon40") else {
            return
        }
        
        firstIcon = UIImageView(image: image)
        self.addSubview(firstIcon)
        firstIcon.autoSetDimension(.width, toSize: 40.0)
        firstIcon.autoSetDimension(.height, toSize: 40.0)
        
        secondIcon = UIImageView(image: image)
        self.addSubview(secondIcon)
        secondIcon.autoSetDimension(.width, toSize: 40.0)
        secondIcon.autoSetDimension(.height, toSize: 40.0)
        secondIcon.autoAlignAxis(.vertical, toSameAxisOf: self)
        
        thirdIcon = UIImageView(image: image)
        self.addSubview(thirdIcon)
        thirdIcon.autoSetDimension(.width, toSize: 40.0)
        thirdIcon.autoSetDimension(.height, toSize: 40.0)
        
        secondIcon.autoPinEdge(.leading, to: .trailing, of: firstIcon, withOffset: 10.0)
        secondIcon.autoPinEdge(.trailing, to: .leading, of: thirdIcon, withOffset: -10.0)
    }
    
    /**
     Updates icons visibility according to new *level* value.
 
     - Parameters:
        - level: current quiz level
    */
    private func updateIcons(level: Int) {
        switch(level) {
        case 0:
            firstIcon.isHidden = true
            secondIcon.isHidden = true
            thirdIcon.isHidden = true
        case 1:
            firstIcon.isHidden = false
            secondIcon.isHidden = true
            thirdIcon.isHidden = true
        case 2:
            firstIcon.isHidden = false
            secondIcon.isHidden = false
            thirdIcon.isHidden = true
        case 3:
            firstIcon.isHidden = false
            secondIcon.isHidden = false
            thirdIcon.isHidden = false
        default:
            fatalError("Level value is out of legal range {0, 1, 2, 3}")
        }
    }
    
}
