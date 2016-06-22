//
//  EditGenderController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/26/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation

class EditGenderController: BaseViewController  {
    
//    @IBOutlet var pickerViewFrom :  UIPickerView!
    @IBOutlet var btnGenderM : UIButton!
    @IBOutlet var btnGenderF : UIButton!
    
    func updateRequiredGender(sender: UIButton){
        
        var gender :NSString = "M"
        if(sender.tag == 1){
            gender = "F"
        }
        
        ProgressHUD.show("Updating...")
        let settings = UserSettings.loadUserSettings()
        let manager = ServiceManager()

        manager.editRequiredGender(gender as String, againstFacebookId: settings.fbId,  sucessBlock: { (isUpdated: Bool) -> Void in
            //code
            ProgressHUD.showSuccess("Updated Successfully")
            
            settings.requiredGender = gender as String
            settings.saveUserSettings()
            self.navigationController?.popViewControllerAnimated(true)
            
            })
            { (error:NSError!) -> Void in
                ProgressHUD.showError("Update Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Gender"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let settings = UserSettings.loadUserSettings()
        let gender = settings.requiredGender as String
        if (gender == "M"){
            self.btnGenderM.highlighted = true
        }
        else{
            self.btnGenderF.highlighted = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func genderSelected(sender: UIButton) {
        self.updateRequiredGender(sender)
    }
}