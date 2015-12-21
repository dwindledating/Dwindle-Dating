//
//  AgeSelectionController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class AgeSelectionController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var pickerViewFrom :  UIPickerView!
    @IBOutlet var pickerViewTo :    UIPickerView!
    @IBOutlet var btnNext       :   UIButton!
    
    var ageFrom: String!
    var ageTo: String!
    
    
    func initContentView(){
        btnNext.layer.cornerRadius = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initContentView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - IBActions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        var ageFrom : Int =  pickerViewFrom.selectedRowInComponent(0)
        ageFrom += 18
        let ageFromStr = String(ageFrom)
        
        var ageTo : Int =  pickerViewTo.selectedRowInComponent(0)
        ageTo += 18
        let ageToStr = String(ageTo)
        
        if (ageFrom > ageTo){
            
            let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            let alert = UIAlertController(title: "Invalid Range", message: "Please Select Valid Range", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(okButton)
            self.presentViewController(alert)

            return
        }
        
        let settings = UserSettings.loadUserSettings()
        settings.userAgeFrom    = ageFromStr
        settings.userAgeTo      = ageToStr
        settings.saveUserSettings()
        
        performSegueWithIdentifier("showDistanceSelector", sender: nil)
    }
    
    // MARK : -Pickerview DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 48;
    }
    
    // MARK : -Pickerview Delegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let x : Int = row + 18
        let title = String(x)
        return title
    }
}
