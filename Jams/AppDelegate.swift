//
//  AppDelegate.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        let jamsViewController = JamsViewController()
        jamsViewController.navigationItem.title = "Jams"
        
        let navigationController = UINavigationController(rootViewController: jamsViewController)
        navigationController.tabBarItem.title = "Jams"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        
        self.window?.rootViewController = tabBarController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

