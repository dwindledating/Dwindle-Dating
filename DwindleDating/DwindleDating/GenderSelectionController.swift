//
//  GenderSelectionController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class GenderSelectionController: UIViewController  {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Gender"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - IBACTIONS
    
    @IBAction func genderSelected(sender: UIButton) {
        
        var gender :NSString = "M"
        if(sender.tag == 1){
            gender = "F"
        }
        
        var settings = UserSettings.loadUserSettings()
        settings.requiredGender = gender as String
        settings.saveUserSettings()
        
        performSegueWithIdentifier("showAgeSelector", sender: nil)
        
    }
    
}