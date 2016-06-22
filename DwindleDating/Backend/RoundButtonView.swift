//
//  RoundButtonView.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 2/15/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit



@objc class RoundButtonView: UIButton {
    
    var borderWidth: CGFloat! = 2.0
    var playerId: String = ""
    
    func initContentView(){
        
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.cornerRadius = (self.frame.size.width)/2.0;
//        self.layer.borderColor = UIColor(red: 1.0, green: 0.0 , blue: 78.0/255.0, alpha: 1.0).CGColor
        self.layer.borderColor = UIColor(red: 181.0/255.0, green: 181.0/255.0 , blue: 181.0/255.0, alpha: 1.0).CGColor
        if borderWidth != nil{
            //use youtConstant you do not need to unwrap `xyz`
            self.layer.borderWidth = borderWidth
        }
        else
        {
            self.layer.borderWidth = 2.0
        }
        self.layer.masksToBounds = true
        
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initContentView()
    }
    
    
}

