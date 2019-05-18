//
//  LoginViewController.swift
//  dz-02
//
//  Created by Jelena Šarić on 09/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import PureLayout

/// Class which presents view controller for login interface.
class LoginViewController: UIViewController {
    
    /// Central views container.
    @IBOutlet weak var viewsContainer: UIView!
    /// Username text field.
    @IBOutlet weak var usernameField: UITextField!
    /// Password text field.
    @IBOutlet weak var passwordField: UITextField!
    /// Login button.
    @IBOutlet weak var loginButton: UIButton!
    /// Information label.
    @IBOutlet weak var infoLabel: UILabel!
    
    /// Constraint which is expected to be modified.
    private var containerCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGUI()
        addKeyboardObservers()
    }
    
    /**
     Tries to establish session with username and password currently stored
     as values in *usernameField* and *passwordField*.
    */
    @IBAction func loginTapped() {
        guard let username = usernameField.text,
              let password = passwordField.text else {
                return
        }
        
        LoginService().establishSession(
            username: username,
            password: password)
            { [weak self] (userId, token) in
                if let userId = userId,
                   let token = token {
                    
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    DispatchQueue.main.async {
                        self?.infoLabel.isHidden = true
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.window?.rootViewController = UINavigationController(
                            rootViewController: QuizzesViewController(quizzesViewModel: QuizzesViewModel())
                        )
                    }
    
                } else {
                    DispatchQueue.main.async {
                        self?.passwordField.text = ""
                        self?.infoLabel.isHidden = false
                    }
                }
            }
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        containerCenterXConstraint =
            NSLayoutConstraint(
                item: viewsContainer,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        self.view.addConstraint(containerCenterXConstraint)
        
        viewsContainer.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        viewsContainer.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40.0)
        viewsContainer.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40.0)
        
        let defaultFont = UIFont.init(name: "Avenir-Book", size: 25.0)
        
        usernameField.font = defaultFont
        usernameField.placeholder = "Username"
        
        usernameField.autoPinEdge(.leading, to: .leading, of: viewsContainer)
        usernameField.autoPinEdge(.trailing, to: .trailing, of: viewsContainer)
        usernameField.autoPinEdge(.top, to: .top, of: viewsContainer, withOffset: 20.0)
        usernameField.autoSetDimension(.height, toSize: 40.0)
        
        passwordField.font = defaultFont
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        
        passwordField.autoPinEdge(.leading, to: .leading, of: usernameField)
        passwordField.autoPinEdge(.trailing, to: .trailing, of: usernameField)
        passwordField.autoPinEdge(.top, to: .bottom, of: usernameField, withOffset: 30.0)
        passwordField.autoSetDimension(.height, toSize: 40.0)
        
        loginButton.titleLabel?.font = defaultFont
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 5.0
        loginButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        
        loginButton.autoPinEdge(.leading, to: .leading, of: usernameField)
        loginButton.autoPinEdge(.trailing, to: .trailing, of: usernameField)
        loginButton.autoPinEdge(.top, to: .bottom, of: passwordField, withOffset: 40.0)
        loginButton.autoSetDimension(.height, toSize: 40.0)
        
        infoLabel.font = UIFont.init(name: "Avenir-Book", size: 15.0)
        infoLabel.text = "Incorrect username and/or password!"
        infoLabel.textAlignment = .center
        infoLabel.isHidden = true
        infoLabel.textColor = UIColor.lightGray
        
        infoLabel.autoPinEdge(.leading, to: .leading, of: viewsContainer)
        infoLabel.autoPinEdge(.trailing, to: .trailing, of: viewsContainer)
        infoLabel.autoPinEdge(.top, to: .bottom, of: loginButton, withOffset: 10.0)
        infoLabel.autoPinEdge(.bottom, to: .bottom, of: viewsContainer, withOffset: -20.0)
        infoLabel.autoSetDimension(.height, toSize: 20.0)
    }
    
    /// Sets up keyboard observers.
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /**
     Defines action which will be executed once keyboard will appear. In this case,
     *fieldContainer*'s horizontal axis is lifted in order to avoid keyboard obscuring
     fields positioned inside of the container.
     
     - Parameters:
        - notification: object which presents keyboard event notification
    */
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = getKeyboardHeight(notification: notification) {
            containerCenterXConstraint.constant = -keyboardHeight / 2.0
            UIView.animate(withDuration: 0.5) { [weak self] () in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    /**
     Defines action which will be executed once keyboard will hide. In this case,
     *fieldContainer*'s horizontal axis is lowered in order to place container in
     it's initial position.
     
     - Parameters:
        - notification: object which presents keyboard event notification
    */
    @objc private func keyboardWillHide(notification: NSNotification) {
        containerCenterXConstraint.constant = 0.0
        UIView.animate(withDuration: 0.5) { [weak self] () in
            self?.view.layoutIfNeeded()
        }
    }
    
    /**
     Calculates keyboard's height from provided parameters.
     
     - Parameters:
        - notification: object which presents keyboard event notification
     
     - Returns: keyboard's height
    */
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat? {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return keyboardFrame.cgRectValue.height
        }
        
        return nil
    }

}
