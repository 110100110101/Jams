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
    
    /**
     These controllers are references to the root view controller that may be used on restoration or from clean run (without restoration)
     
     These controllers are initialized on `application(_:viewControllerWithRestorationIdentifierPath:coder:)` and referenced back to
     `application(_:didFinishLaunchingWithOptions:) ` for further setup
     */
    
    private var rootTabBarController: UITabBarController?
    private var jamsNavigationController: UINavigationController?
    private var myJamsNavigationController: UINavigationController?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UITabBar.appearance().tintColor = .systemPink
        UIButton.appearance().tintColor = .systemPink
        UIBarButtonItem.appearance().tintColor = .systemPink
        UISearchBar.appearance().tintColor = .systemPink
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        /*
         The `nil` checks are added to prevent overriding the setup have been done on each
         "root" view controllers, referenced above
         */
        
        /*
         JAMS
         */
        
        if self.jamsNavigationController == nil {
            
            let jamsDataSource = JamsDataSource()
            let jamsViewModel = JamsViewModel(dataSource: jamsDataSource)
            let jamsViewController = JamsViewController(viewModel: jamsViewModel) // Restoration ID was set at nib
            let jamsNavigationController = UINavigationController(rootViewController: jamsViewController)
            jamsNavigationController.restorationIdentifier = "Jams_UINavigationController"
            
            let jamsImage = UIImage(systemName: "play.tv.fill")
            jamsNavigationController.tabBarItem.image = jamsImage
            jamsNavigationController.tabBarItem.title = "Jams"
            
            self.jamsNavigationController = jamsNavigationController
        }
        
        /*
         MY JAMS
         */
        
        if self.myJamsNavigationController == nil {
            
            let myJamsDataSource = MyJamsDataSource()
            let myJamsViewModel = MyJamsViewModel(dataSource: myJamsDataSource)
            let myJamsViewController = MyJamsViewController(viewModel: myJamsViewModel) // Restoration ID was set at nib
            let myJamsNavigationController = UINavigationController(rootViewController: myJamsViewController)
            myJamsNavigationController.restorationIdentifier = "MyJams_UINavigationController"
            
            let myJamsImage = UIImage(systemName: "heart.fill")
            myJamsNavigationController.tabBarItem.image = myJamsImage
            myJamsNavigationController.tabBarItem.title = "My Jams"
            
            self.myJamsNavigationController = myJamsNavigationController
        }
        
        if self.rootTabBarController == nil {
         
            let rootTabBarController = UITabBarController()
            rootTabBarController.restorationIdentifier = "Root_UITabBarController"
            
            self.rootTabBarController = rootTabBarController
        }
        
        guard let jamsNavigationController = self.jamsNavigationController else {
            fatalError("jamsNavigationController should be initialized at this point!")
        }
        
        guard let myJamsNavigationController = self.myJamsNavigationController else {
            fatalError("myJamsNavigationController should be initialized at this point!")
        }
        
        self.rootTabBarController?.viewControllers = [jamsNavigationController, myJamsNavigationController]
        self.window?.rootViewController = self.rootTabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        
        let identifierComponent = identifierComponents.last
        switch identifierComponent {
        
        case "Root_UITabBarController":
            self.initializeRootTabBarController()
            return self.rootTabBarController
        case "Jams_UINavigationController":
            self.initializeJamsNavigationController()
            return self.jamsNavigationController
        case "MyJams_UINavigationController":
            self.initializeMyJamsNavigationController()
            return self.myJamsNavigationController
        default:
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    /*
     These methods below are used to initialize the root view controllers only; excluding their `viewControllers`
     */
    
    private func initializeRootTabBarController() {
        
        let tabBarController = UITabBarController()
        tabBarController.restorationIdentifier = "Root_UITabBarController"
        
        self.rootTabBarController = tabBarController
    }
    
    private func initializeJamsNavigationController() {
        
        let jamsNavigationController = UINavigationController()
        jamsNavigationController.restorationIdentifier = "Jams_UINavigationController"
        
        let jamsImage = UIImage(systemName: "play.tv.fill")
        jamsNavigationController.tabBarItem.image = jamsImage
        jamsNavigationController.tabBarItem.title = "Jams"
        
        self.jamsNavigationController = jamsNavigationController
    }
    
    private func initializeMyJamsNavigationController() {
        
        let myJamsNavigationController = UINavigationController()
        myJamsNavigationController.restorationIdentifier = "MyJams_UINavigationController"
        
        let myJamsImage = UIImage(systemName: "heart.fill")
        myJamsNavigationController.tabBarItem.image = myJamsImage
        myJamsNavigationController.tabBarItem.title = "My Jams"
        
        self.myJamsNavigationController = myJamsNavigationController
    }
}

