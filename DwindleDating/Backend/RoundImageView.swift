//
//  RoundImageController.swift
//  testproject
//
//  Created by Yunas Qazi on 2/11/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

import UIKit

@objc class RoundImageView: UIImageView {
    
    var borderWidth: CGFloat?
    
    func initContentView(){
        
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.cornerRadius = (self.frame.size.width)/2.0;
        self.layer.borderColor = UIColor(red: 181.0/255.0, green: 181.0/255.0 , blue: 181.0/255.0, alpha: 1.0).CGColor
        self.layer.borderWidth = borderWidth!
        self.layer.masksToBounds = true
        
        print(NSStringFromCGRect(self.bounds))
        print(NSStringFromCGRect(self.frame))
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initContentView()
    }
    
}

