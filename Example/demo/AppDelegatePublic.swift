//
//  AppDelegatePublic.swift
//  demo
//
//  Created by Laurent Grandhomme on 9/13/16.
//  Copyright © 2016 Element. All rights reserved.
//

import UIKit

#if !(targetEnvironment(simulator))
import ElementSDK
#endif

@UIApplicationMain
class AppDelegatePublic: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
#if !(targetEnvironment(simulator))
        // TODO: replace YOUR_EAK with the EAK provided by Element
        ElementSDKConfiguration.shared().initialize(withConfigurationData: "YOUR_EAK")
        
        // geo locate user during authentication (default is false)
        ElementSDKConfiguration.shared().geolocateUser = false
        
        // theme: requires the asset bundles
        ElementSDKConfiguration.shared().theme = .flowerPetals
#endif

        let vc = MainViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
        
        return true
    }
}

