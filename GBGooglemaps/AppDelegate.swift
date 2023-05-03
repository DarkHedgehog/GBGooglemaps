//
//  AppDelegate.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 28.03.2023.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBJgja5MmDDMGXvKQmcgzHyUMt4BvXpQTw")

        NotificationService.shared.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.present()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print ("applicationWillResignActive")
        NotificationService.shared.sendNotification()
        appCoordinator?.lockScreen()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print ("applicationDidBecomeActive")
        appCoordinator?.unlockScreen()
    }


//    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
}
