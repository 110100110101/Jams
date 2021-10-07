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
        
        UIButton.appearance().tintColor = .systemPink
        UISearchBar.appearance().tintColor = .systemPink
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        let jamsViewController = JamsViewController()
        let jamsNavigationController = UINavigationController(rootViewController: jamsViewController)
        jamsNavigationController.tabBarItem.title = "Jams"
        
        let myJamsViewController = MyJamsViewController()
        let myJamsNavigationController = UINavigationController(rootViewController: myJamsViewController)
        myJamsNavigationController.tabBarItem.title = "My Jams"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [jamsNavigationController, myJamsNavigationController]
        
        self.window?.rootViewController = tabBarController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

