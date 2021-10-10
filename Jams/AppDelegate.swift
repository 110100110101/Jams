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
        
        UITabBar.appearance().tintColor = .systemPink
        UIButton.appearance().tintColor = .systemPink
        UIBarButtonItem.appearance().tintColor = .systemPink
        UISearchBar.appearance().tintColor = .systemPink
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        let jamsDataSource = JamsDataSource()
        let jamsViewModel = JamsViewModel(dataSource: jamsDataSource)
        let jamsViewController = JamsViewController(viewModel: jamsViewModel)
        let jamsNavigationController = UINavigationController(rootViewController: jamsViewController)
        jamsNavigationController.tabBarItem.title = "Jams"
        
        let jamsImage = UIImage(systemName: "play.tv.fill")
        jamsNavigationController.tabBarItem.image = jamsImage
        
        let myJamsViewModel = MyJamsViewModel()
        let myJamsViewController = MyJamsViewController(viewModel: myJamsViewModel)
        let myJamsNavigationController = UINavigationController(rootViewController: myJamsViewController)
        myJamsNavigationController.tabBarItem.title = "My Jams"
        
        let myJamsImage = UIImage(systemName: "heart.fill")
        myJamsNavigationController.tabBarItem.image = myJamsImage
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [jamsNavigationController, myJamsNavigationController]
        
        self.window?.rootViewController = tabBarController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

