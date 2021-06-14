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
        ElementSDKConfiguration.shared().initialize(withConfigurationData: "EREREV/lCqP9INPjZByL6KSjG+uYdKV6WwAsSjLXG5ctMHNEKYPBVMwtNhWGZlRUgMp8iEVezFElNTycSqHYYZlsYAw2xTWkUs9w1o4b5bdQKbTqqHPPHouNM70zlo+OA2Upvx+sIgh3UnYI18N4E022cAiKGr8Fo26MBQ7/260yrsED+mFsJM5kxY2yb/lgbwPMiS4/2G4YBAvwq5NQd7X2roiR2Gz1O2qXVH/2iuvRBXn6Mz/S5G17Ox1LUpOWs53RD0uHAYlHX+EFZmbUvoPHZ0/gGPn2asCBMbaKkTKevUjn+gNSlYY4W81lybVQu+pyS+o3V/7hh27nsHn4FwK3+vSaPGO2AsXCJ2qFsyMyO4Thv9dv5yHEW4vVwadXMoJJyqe1g4/HNEIU8jkOP4JRbeWi+DlbREXOhXw2d84Vdscp14gqk+oSiDZN4NS2cdAU5DtP1GROD0wUUR9S4dFjFWbn11zAucnzcUWKZI0o22/55zYqsn9QYzWdrvdjygWFFMbxzVGuem1wtFtNz4BdDojJll9AVVESIBIJqZGuhXiF9dOmOdGIHH1u4ISk8ePo1D5qM+NWTcAOaz+Y8n+X1OYCzD2cA9d39c1FqUHnMAfVf9+lllUVh4YdVf0UrZ76GHdBVNIO5MxdBszgxXacKkgsi/0/qtOt8yNXG6F7IaDwQcf/j3+6Q5kJo9v1KcHLpttcZLBCFO8oJfr4cAOX8p+IA3Licfp7nvYwziMJ+zdYcujPt4hqlsZGn6F2d7WqMU0y0LhFpsH/SWRDw/cZNGUCyGVdqsYvdVCJWVJmZAHR4gDzDxePl9KvHoquzn4ZJKFbg1W4R7BB6tM4thgd2DSAjHvGvwSG5+gcEhGri2yDg8bCWQfnb/K9IE35tniM/OZdZUYq7SIulbM0r2EmyDYA8fwtDFLepGnoQcuXEUzgLd2IXUJAJwSYw0gmCKdt444XwrBdEEx1F/vZsUaphrQDdmG+VxWn7hSxk1Z8XgVSswwwsQ9/4hnrgcpuhqjTihci7/XFUksXDBX7I8Y/qYTvWVqUtA==")
        
        // theme: requires the asset bundles
        ElementSDKConfiguration.shared().theme = .flowerPetals
#endif

        let vc = MainViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
        
        return true
    }
}

