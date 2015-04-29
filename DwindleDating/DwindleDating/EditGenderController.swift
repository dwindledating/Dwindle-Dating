//
//  EditGenderController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/26/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation

class EditGenderController: UIViewController  {
    
//    @IBOutlet var pickerViewFrom :  UIPickerView!
    @IBOutlet var btnGenderM : UIButton!
    @IBOutlet var btnGenderF : UIButton!
    
    func updateRequiredGender(sender: UIButton){
        
        var gender :NSString = "M"
        if(sender.tag == 1){
            gender = "F"
        }
        
        ProgressHUD.show("Updating...")
        var settings = UserSettings.loadUserSettings()
        var manager = ServiceManager()

        manager.editRequiredGender(gender as String, againstFacebookId: settings.fbId,  sucessBlock: { (isUpdated: Bool) -> Void in
            //code
            ProgressHUD.showSuccess("Updated Successfully")
            
            settings.userGender = gender as String
            settings.saveUserSettings()
            self.navigationController?.popViewControllerAnimated(true)
            
            
            }) { (error:NSError!) -> Void in
                //code
                ProgressHUD.showError("Update Failed")
        }
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Edit Gender"
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        var settings = UserSettings.loadUserSettings()
        var gender = settings.userGender as String
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
    
    // MARK : - IBACTIONS
    
    @IBAction func genderSelected(sender: UIButton) {
      
        self.updateRequiredGender(sender)
        
    }
    
}