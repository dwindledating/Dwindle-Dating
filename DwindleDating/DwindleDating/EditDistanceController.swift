//
//  EditDistanceController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/26/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation

class EditDistanceController: BaseViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var pickerViewDistance :  UIPickerView!
    @IBOutlet var btnNext            :  UIButton!
    
    
    func updateUserDistance(){
        
        ProgressHUD.show("Updating...")
        let settings = UserSettings.loadUserSettings()
        let manager = ServiceManager()
        
        var row = pickerViewDistance.selectedRowInComponent(0)
            row = ((row + 1) * 5)
        let rowNumber: NSNumber = row
        
        manager.editDistance(rowNumber, againstFacebookId: settings.fbId, sucessBlock: { (isUpdated: Bool) -> Void in
            
                ProgressHUD.showSuccess("Updated Successfully")
            
                let distanceStr = String(row)
                let settings = UserSettings.loadUserSettings()
                settings.userDistance    = distanceStr
                settings.saveUserSettings()
                
                self.navigationController?.popViewControllerAnimated(true)
            
            
            }) { (error:NSError!) -> Void in
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

        let settings = UserSettings.loadUserSettings()
        let distance = Int(settings.userDistance as String)
        if var distanceInt = distance {
            distanceInt = (distanceInt - 1) / 5
            pickerViewDistance.selectRow(distanceInt, inComponent: 0, animated: true)
        }
        else
        {
            pickerViewDistance.selectRow(0, inComponent: 0, animated: true)
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

        self.updateUserDistance()
    }
    
    // MARK : -Pickerview DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 1) { return 1}
        return 10
    }
    
    // MARK : -Pickerview Delegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 1) { return "miles"}
        let title = "  " + String(format: "%02d", ((row + 1) * 5))
        return title
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if (component == 0){
            return 50
        }
        return 75
    }
    
    
    
    
}