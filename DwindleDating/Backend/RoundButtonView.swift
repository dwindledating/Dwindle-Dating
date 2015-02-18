//
//  RoundButtonView.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 2/15/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

class RoundButtonView: UIButton {
    
    var borderWidth: CGFloat!
    
    func initContentView(){
        
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.cornerRadius = (self.frame.size.width)/2.0;
        self.layer.borderColor = UIColor.blueColor().CGColor
//        if let borderWidth = nil{
//            //use youtConstant you do not need to unwrap `xyz`
//            self.layer.borderWidth = 5.0
//
//        }
//        else
//        {
            self.layer.borderWidth = borderWidth
//        }
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

