//
//  AppDelegate.swift
//  ManaKit
//
//  Created by jovito-royeca on 07/17/2017.
//  Copyright (c) 2017 jovito-royeca. All rights reserved.
//

import UIKit
import ManaKit
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")

        if ManaKit.sharedInstance.needsUpgrade() {
            // Create database
            let maintainer = Maintainer()
            maintainer.startActivity(name: "Create data...")
            maintainer.unpackScryfallData()

            firstly {
                maintainer.fetchSetsAndCreateCards()
            }.then {
                maintainer.updateSetSymbols()
            }.then {
                maintainer.updateOtherCardInformation()
            }.then {
                maintainer.createComprehensiveRules()
            }.done {
                maintainer.compactDatabase()
                maintainer.endActivity()
                UserDefaults.standard.set(ManaKit.Constants.ScryfallDate, forKey: ManaKit.UserDefaultsKeys.ScryfallDate)
                UserDefaults.standard.synchronize()
                
                ManaKit.sharedInstance.setupResources()
                ManaKit.sharedInstance.configureTcgPlayer(partnerKey: "ManaGuide",
                                                          publicKey: "A49D81FB-5A76-4634-9152-E1FB5A657720",
                                                          privateKey: "C018EF82-2A4D-4F7A-A785-04ADEBF2A8E5")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: MaintainerKeys.MaintainanceDone),
                                                object: nil,
                                                userInfo: nil)
            }.catch { error in
                print(error)
            }
        } else {
            // Normal run
            ManaKit.sharedInstance.setupResources()
            ManaKit.sharedInstance.configureTcgPlayer(partnerKey: "ManaGuide",
                                                      publicKey: "A49D81FB-5A76-4634-9152-E1FB5A657720",
                                                      privateKey: "C018EF82-2A4D-4F7A-A785-04ADEBF2A8E5")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

