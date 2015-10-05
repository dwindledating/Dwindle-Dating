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
        rowFrom = rowFrom + 18
        let rowNumberFrom: NSNumber = rowFrom

        var rowTo = pickerViewTo.selectedRowInComponent(0)
        rowTo = rowTo + 18
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
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var settings = UserSettings.loadUserSettings()
        print(settings.userAgeTo)
        var ageTo = Int(settings.userAgeTo as String)
        if var ageToInt = ageTo {
            ageToInt = ageToInt - 18
            pickerViewTo.selectRow(ageToInt, inComponent: 0, animated: true)
        }
        else
        {
            pickerViewTo.selectRow(0, inComponent: 0, animated: true)
        }

        
        var ageFrom = Int(settings.userAgeFrom as String)
        if var ageFromInt = ageFrom {
            if (ageFromInt > 0){
                ageFromInt = ageFromInt - 18
            }
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
        
        let ageFrom : Int =  pickerViewFrom.selectedRowInComponent(0)
        var ageFromStr = String(ageFrom)
        
        let ageto : Int =  pickerViewTo.selectedRowInComponent(0)
        var ageToStr = String(ageto)
        
        if (ageFrom > ageto){
            UIAlertView(title: "Invalid Range", message: "Please Select Valid Range" , delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }

        self.updateUserAge()

        
    }
    
    
    
    // MARK : -Pickerview DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK : -Pickerview Delegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 48;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let x : Int = row + 18
        var title = String(x)
        return title
    }
    
    
    
    
}