//
//  DataStoreRealTimeChatApp.swift
//  DataStoreRealTimeChat
//
//  Created by Manthena, Manaswi on 9/24/22.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            Amplify.Logging.logLevel = .verbose
            let awsCognitoAuthPlugin = AWSCognitoAuthPlugin()
            try Amplify.add(plugin: awsCognitoAuthPlugin)
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        return true
    }
}

@main
struct DataStoreRealTimeChatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            UserLogInView()
        }
    }
}
