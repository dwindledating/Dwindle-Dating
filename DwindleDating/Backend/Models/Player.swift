//
//  Player.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/16/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation



class Player: NSObject {
    
    var fb_id: NSString // no need (!). It will be initialised from controller
    var imgPath: NSURL
    
    init(fromFbId fbId: NSString, fromImagePath imgPath: NSString) {
        self.fb_id = fbId
        self.imgPath = NSURL(string: imgPath)!
        super.init()
    }
    
    convenience override init() {
        self.init(fromFbId:"", fromImagePath:"") // calls above mentioned controller with default name
    }
}