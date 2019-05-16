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
        // let navigationController: UINavigationController
        if UserDefaults.standard.string(forKey: "token") != nil {
            // inicijaliziraj navigation controller s ekranom kvizeva
        } else {
            // inicijaliziraj navigation controller s login ekranom
        }
        
        // window?.rootViewController = navigationController
        window?.rootViewController = QuizzesViewController(viewModel: QuizzesViewModel())
        window?.makeKeyAndVisible()
        
        return true
    }

}

