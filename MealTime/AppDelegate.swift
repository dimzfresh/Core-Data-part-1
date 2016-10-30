//
//  AppDelegate.swift
//  MealTime
//
//  Created by Dimz on 15.10.16.
//  Copyright © 2016 Dmitriy Zyablikov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationController = window!.rootViewController as! UINavigationController
        let viewController = navigationController.topViewController as! ViewController
        
        viewController.managedObjectContext = coreDataStack.context
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.save()
    }

 }

