//
//  UserSettings.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation


//class UserSettings {
//    class var sharedInstance : UserSettings {
//        struct Singleton {
//            static let instance = UserSettings()
//        }
//        return Singleton.instance
//    }
//    
//    var number = ""
//}


private let _sharedInstance = UserSettings()

class UserSettings:NSCoding {

    var userGender      = ""
    var userDistance    = ""
    var userAgeFrom     = ""
    var userAgeTo       = ""

    class var sharedInstance: UserSettings {
        return _sharedInstance
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userGender, forKey: "userGender")
//        aCoder.encodeObject(userDistance, forKey: "")
        
    }
    
    
    
//    init(coder aDecoder: NSCoder) {
//        self.myArray = aDecoder.decodeObjectForKey("myArray") as String[]
//    }
}

//class UserSettings: NSObject {
//
//
//    
//    override init() {
//        self = super.init()
//        if (self){
//            
//            self.userGender     = ""
//            self.userAgeFrom    = ""
//            self.userDistance   = ""
//            self.userAgeTo      = ""
//        }
//    }
//    
//}
//@interface AppSettings : NSObject<NSCoding>
//
//@property (nonatomic, assign) BOOL isfirstLaunch;
//@property (nonatomic, strong) NSString* userSelectedGate;
//
//+(AppSettings *) loadAppSettings;
//-(void)saveTheAppSetting;

