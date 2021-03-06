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
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UITabBar.appearance().tintColor = .systemPink
        UIButton.appearance().tintColor = .systemPink
        UIBarButtonItem.appearance().tintColor = .systemPink
        UISearchBar.appearance().tintColor = .systemPink
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        /*
         Jams
         */
        
        let jamsDataSource = JamsDataSource()
        let jamsViewModel = JamsViewModel(dataSource: jamsDataSource)
        let jamsViewController = JamsViewController(viewModel: jamsViewModel) // Restoration ID was set at nib
        let jamsNavigationController = UINavigationController(rootViewController: jamsViewController)
        jamsNavigationController.restorationIdentifier = "Jams_UINavigationController"
        
        let jamsImage = UIImage(systemName: "play.tv.fill")
        jamsNavigationController.tabBarItem.image = jamsImage
        jamsNavigationController.tabBarItem.title = "Jams"
        
        /*
         My Jams
         */
        
        let myJamsDataSource = MyJamsDataSource()
        let myJamsViewModel = MyJamsViewModel(dataSource: myJamsDataSource)
        let myJamsViewController = MyJamsViewController(viewModel: myJamsViewModel) // Restoration ID was set at nib
        let myJamsNavigationController = UINavigationController(rootViewController: myJamsViewController)
        myJamsNavigationController.restorationIdentifier = "MyJams_UINavigationController"
        
        let myJamsImage = UIImage(systemName: "heart.fill")
        myJamsNavigationController.tabBarItem.image = myJamsImage
        myJamsNavigationController.tabBarItem.title = "My Jams"
        
        /*
         Root
         */
        
        let tabBarController = UITabBarController()
        tabBarController.restorationIdentifier = "Root_UITabBarController"
        tabBarController.viewControllers = [jamsNavigationController, myJamsNavigationController]
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        
        /*
         If the saved version and the current version don't match, don't bother
         restoring it
         */
        
        let savedVersion = coder.decodeObject(forKey: UIApplication.stateRestorationBundleVersionKey) as? String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        
        return savedVersion == currentVersion
    }
}

