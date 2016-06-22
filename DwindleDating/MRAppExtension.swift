//
//  MRAppExtension.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 12/04/2016.
//  Copyright © 2016 infinione. All rights reserved.
//

import UIKit

private let MRLastAppVersionKey = "MRlastAppVersion"

public extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    public var appVersion: String {
        guard let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String else {
            
            return ""
        }
        return version
    }
    
    public var appBuildVersion: String {
        
        guard let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String else {
            return ""
        }
        return build
    }
    
    public func applicationUpdateBlock(closure: (data:Bool) -> Void) {
       
        if isAppUpdated() {
            closure(data: true)
        }
    }
    
    public func isAppUpdated() -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if  let savedVersion = userDefaults.stringForKey("currentVersion") where savedVersion.compare(appVersion, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) == .OrderedAscending {
            return true
        }
        
        userDefaults.setObject(appVersion, forKey: "currentVersion")
        userDefaults.synchronize()
        return false
    }
}
