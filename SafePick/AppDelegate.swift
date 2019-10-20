//
//  AppDelegate.swift
//  SafePick
//
//  Created by 김성현 on 28/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var courierManager = CourierManager.shared
    
    static let DateKey = "lastUpdatedDate"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = .redOrange
        
        firstLaunchOption()
        
        autoUpdateData()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: 비공개 메소드
    
    private func updateCourier() {
        
        courierManager.updateData(complition: nil)
        UserDefaults.standard.set(Date(), forKey: AppDelegate.DateKey)
        os_log("데이터가 업데이트 됨", log: OSLog.default, type: .info)
    }
    
    private func firstLaunchOption() {
        let firstLaunchKey = "launchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: firstLaunchKey)
        if !launchedBefore {
            
            window?.makeKeyAndVisible()
            courierManager.updateDataWithAlert(source: window?.rootViewController) {
                UserDefaults.standard.set(true, forKey: firstLaunchKey)
            }
        }
    }
    
    private func autoUpdateData() {
        
        guard let lastUpdated = UserDefaults.standard.object(forKey: AppDelegate.DateKey) else {
            updateCourier()
            os_log("마지막 업데이트 날짜를 찾을 수 없음, 데이터가 업데이트 됨", log: OSLog.default, type: .info)
            return
        }
        
        let lastUpdatedDate = lastUpdated as! Date
        let timeInterval = Date().timeIntervalSince(lastUpdatedDate)
        
        // 일주일이 지나면 업데이트합니다.
        if timeInterval > 604800 {
            updateCourier()
            os_log("마지막 업데이트로부터 7일이 지나 데이터가 업데이트 됨.", log: OSLog.default, type: .info)
        }
    }
}

