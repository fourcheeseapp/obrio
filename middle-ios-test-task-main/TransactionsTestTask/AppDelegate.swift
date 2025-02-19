//
//  AppDelegate.swift
//  TransactionsTestTask
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }
}

// MARK: - Private 
private extension AppDelegate {
    func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let appRouter = AppRouter(window: window)
        appRouter.start()
    }
}
