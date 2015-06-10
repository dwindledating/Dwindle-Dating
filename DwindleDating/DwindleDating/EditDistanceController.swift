//
//  EditDistanceController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/26/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation

class EditDistanceController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var pickerViewDistance :  UIPickerView!
    @IBOutlet var btnNext       :   UIButton!
    
    
    func updateUserDistance(){
        
        ProgressHUD.show("Updating...")
        var settings = UserSettings.loadUserSettings()
        var manager = ServiceManager()
        
        var row = pickerViewDistance.selectedRowInComponent(0)
            row = ((row + 1) * 5)
        let rowNumber: NSNumber = row
        
        manager.editDistance(rowNumber, againstFacebookId: settings.fbId, sucessBlock: { (isUpdated: Bool) -> Void in
            //code
                ProgressHUD.showSuccess("Updated Successfully")
            
                var distanceStr = String(row)
                var settings = UserSettings.loadUserSettings()
                settings.userDistance    = distanceStr
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
        var distance = (settings.userDistance as String).toInt()
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
    
    
    // MARK : -Pickerview Delegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 1) { return 1}
        
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (component == 1) { return "miles"}
        var title = "  " + String(format: "%02d", ((row + 1) * 5))
        return title
    }
    
    //    - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if (component == 0){
            return 50
        }
        return 75
    }
    
    
    
    
}