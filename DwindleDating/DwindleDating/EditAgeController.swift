//
//  EditAgeController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/26/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation



class EditAgeController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var pickerViewFrom :  UIPickerView!
    @IBOutlet var pickerViewTo :    UIPickerView!
    @IBOutlet var btnNext       :   UIButton!
    
    
    
    func updateUserAge(){
        
        ProgressHUD.show("Updating...")
        var settings = UserSettings.loadUserSettings()
        var manager = ServiceManager()
        
        var rowFrom = pickerViewFrom.selectedRowInComponent(0)
        let rowNumberFrom: NSNumber = rowFrom

        var rowTo = pickerViewTo.selectedRowInComponent(0)
        let rowNumberTo: NSNumber = rowTo

        manager.editAgeFromRange(rowNumberFrom, andToRange: rowNumberTo, againstFacebookId:settings.fbId,  sucessBlock: { (isUpdated: Bool) -> Void in
            //code
            ProgressHUD.showSuccess("Updated Successfully")
            
            var rowFromStr = String(rowFrom)
            var rowToStr = String(rowTo)
            var settings = UserSettings.loadUserSettings()
            settings.userAgeFrom    = rowFromStr
            settings.userAgeTo      = rowToStr
            settings.saveUserSettings()
            
            self.navigationController?.popViewControllerAnimated(true)
            
            
            }) { (error:NSError!) -> Void in
                //code
                ProgressHUD.showError("Update Failed")
        }
        
    }

    
    
    func initContentView(){
        btnNext.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var settings = UserSettings.loadUserSettings()
        var ageTo = (settings.userAgeTo as String).toInt()
        if let ageToInt = ageTo {
            pickerViewTo.selectRow(ageToInt, inComponent: 0, animated: true)
        }
        else
        {
            pickerViewTo.selectRow(0, inComponent: 0, animated: true)
        }

        
        var ageFrom = (settings.userAgeFrom as String).toInt()
        if let ageFromInt = ageFrom {
            pickerViewFrom.selectRow(ageFromInt, inComponent: 0, animated: true)
        }
        else
        {
            pickerViewFrom.selectRow(0, inComponent: 0, animated: true)
        }

        
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
        
        self.updateUserAge()

        
    }
    
    
    
    // MARK : -Pickerview DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK : -Pickerview Delegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 80;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let x : Int = row
        var title = String(x)
        return title
    }
    
    
    
    
}