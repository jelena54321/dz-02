//
//  AppDelegate.swift
//  dz-02
//
//  Created by Jelena Šarić on 09/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaults.standard.string(forKey: "token") != nil {
            window?.rootViewController = UINavigationController(
                rootViewController: QuizzesViewController(quizzesViewModel: QuizzesViewModel())
            )
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
        return true
    }

}

