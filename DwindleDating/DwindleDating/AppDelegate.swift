//
//  AppDelegate.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/15/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

//let BFTaskMultipleExceptionsException = "BFMultipleExceptionsException";
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var playController: GamePlayController!
    private(set) var matchChatController: MatchChatController!
    var apsUserInfo: [String:AnyObject]? = nil
    
    var window: UIWindow?
    
    class func sharedAppDelegat() -> AppDelegate {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate
    }
    
    func registerForPushNotifications(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?){
        
        //Setup
        Parse.setApplicationId("HEQ0TQq0Qvqdy7BAGii05miGcVp5AcvGbnvdhxQd",
            clientKey: "nXBmYwFcFaWLnykLWFL2NQpY5XSLyC5MbnRrCUKc")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(
                    launchOptions, block: { (status:Bool, error:NSError?) -> Void in
                        //code
                })
            }
        }
        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
 
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
//        PFPush.handlePush(userInfo)
        
        if application.applicationState == UIApplicationState.Inactive {

            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: { (status:Bool, error:NSError?) -> Void in
            })
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        CleverTap.sharedInstance().notifyApplicationLaunchedWithOptions(launchOptions)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.handlePushNotification(_:)), name: PushNotification, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        playController = storyboard.instantiateViewControllerWithIdentifier(GamePlayController.nameOfClass) as! GamePlayController
        matchChatController = storyboard.instantiateViewControllerWithIdentifier(MatchChatController.nameOfClass) as! MatchChatController

        self.registerForPushNotifications(application, didFinishLaunchingWithOptions: launchOptions)
        
        FBLoginView.self
        FBProfilePictureView.self
        
        self.updateAppearance(application)
        
        if let launchOption = launchOptions,
            let userInfo = launchOption[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String:AnyObject] {
                // Application is launched because of Push notification.
            apsUserInfo = userInfo
        }
        
        self.askToEnableLocationServices()
        
        return true
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //code
        let wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        let nav = self.window?.rootViewController as! UINavigationController
        
        if nav.isViewControllerinNavigationStack(self.playController) {
//            self.playController.resetGameViews()
//            nav.popViewControllerAnimated(false)
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let dwindleSocket = DwindleSocketClient.sharedInstance
        dwindleSocket.disconnect()
    }

    //MARK: UIAppearance
    
    private func updateAppearance(application:UIApplication) {
        
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = UIColor(red: 0/255.0, green: 129/255.0, blue: 173/255.0 , alpha: 1.0)
        navigationBarAppearace.barStyle = UIBarStyle.Default
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handlePushNotification(notif:NSNotification) {
        // Check for push notification
        
        print("handlePushNotification")
        
        if let apsUserInfo = self.apsUserInfo {
            
            print(apsUserInfo)
            
            let settings = UserSettings.loadUserSettings()
            let otherUserFbid = apsUserInfo["fromUserFbId"] as! String
            let nav = self.window?.rootViewController as! UINavigationController
            
            if let playEvent = apsUserInfo["playEvent"] as? NSNumber where playEvent == 1 {
                
                // Suppose we have play event
                
                let manager = ServiceManager()
                manager.getUserLocation({ (location: CLLocation!) -> Void in
                    
                    print("Sending 'apnsResponse' =>\(settings.fbId) and lon => \(location.coordinate.longitude) and lat => \(location.coordinate.latitude) ")
                    
                    let data:[AnyObject] = [settings.fbId, otherUserFbid, location.coordinate.latitude,location.coordinate.longitude]
                    
                    let dwindleSocket = DwindleSocketClient.sharedInstance
                    dwindleSocket.sendEvent("apnsResponse", data: data)
                    
                    let playController = self.playController
                    playController.gameInProgress = false
                    playController.isComingFromOtherScreen = true
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        nav.viewControllers.append(playController)
                        playController.show90SecTimer()
                        self.apsUserInfo = nil
                    })
                    
                    }, failure: { (error:NSError!) -> Void in
                        
                        print("Error Message =>\(error.localizedDescription)")
                        ProgressHUD.showError("Please turn on your location from Privacy Settings in order to play the game.")
                })
            }
            else {
                
                ProgressHUD.dismiss()
                nav.setNavigationBarHidden(false, animated: false)
                
                let matchControler = self.matchChatController
                matchControler.isComingFromPlayScreen = true
                matchControler.toUserId = otherUserFbid
                matchControler.toUserName = apsUserInfo["fromUserName"] as! String
                matchControler.status = ""
                nav.viewControllers.append(matchControler)
                self.apsUserInfo = nil
            }
        }
    }
    
    func askToEnableLocationServices() {
        
        let manager = ServiceManager()
        manager.getUserLocation({ (location) -> Void in
            
            print("user current location => \(location)");
            
            }) { (error) -> Void in
                
                ProgressHUD.showError("Please turn on your location from Privacy Settings in order to play the game.")
                let delay = 3.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    ProgressHUD.dismiss()
                }
        }
    }
}

