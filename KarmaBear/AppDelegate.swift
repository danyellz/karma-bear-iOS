//
//  AppDelegate.swift
//  Selfie
//
//  Created by Behera, Subhransu on 29/8/14.
//  Copyright (c) 2014 subhb.org. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func application(application: UIApplication,
                     openURL url: URL,
                             sourceApplication: String?,
                             annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
}

