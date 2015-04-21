//
//  PictureSelectionController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit
import MobileCoreServices



class PictureSelectionController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var btnPicture1       :   RoundButtonView!
    @IBOutlet var btnPicture2       :   RoundButtonView!
    @IBOutlet var btnPicture3       :   RoundButtonView!
    @IBOutlet var btnPicture4       :   RoundButtonView!
    @IBOutlet var btnPicture5       :   RoundButtonView!
    @IBOutlet var btnNext       :   UIButton!
    
    
    var btnOpener : UIButton?
    
    func initContentView(){
        btnNext.layer.cornerRadius = 5.0
        
        self.btnPicture1.borderWidth = 3.0;
        self.btnPicture2.borderWidth = 3.0;
        self.btnPicture3.borderWidth = 3.0;
        self.btnPicture4.borderWidth = 3.0;
        self.btnPicture5.borderWidth = 3.0;
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
    
    
    // MARK : - WEBSERVICE

    
    func validateAllImages () -> Bool{
        
        if(!btnPicture1.userInteractionEnabled &&
           !btnPicture2.userInteractionEnabled &&
            !btnPicture3.userInteractionEnabled &&
            !btnPicture4.userInteractionEnabled &&
            !btnPicture5.userInteractionEnabled){
                return true
        }
        return false
    }
    
    
    func signup (){
        self.performSegueWithIdentifier("showMenuController", sender: nil)

        return
        
//        if(!self.validateAllImages()){
//            let myAlert: UIAlertController = UIAlertController(title: title, message: "Please provide all 5 images to proceed", preferredStyle: .Alert)
//            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(myAlert, animated: true, completion: nil)
//            return
//        }
        
        println("validate all images\(self.validateAllImages())")
        var settings = UserSettings.loadUserSettings()

        println("User Gender \(settings.userGender)")
        println("User Distance \(settings.userDistance)")
        println("From Age \(settings.userAgeFrom)")
        println("to Age \(settings.userAgeTo)")
        println("to distance \(settings.userDistance)")
        
            var imagesArr = [UIImage]()
        
            imagesArr.append(btnPicture1.imageForState(UIControlState.Normal)!)
            imagesArr.append(btnPicture2.imageForState(UIControlState.Normal)!)
            imagesArr.append(btnPicture3.imageForState(UIControlState.Normal)!)
            imagesArr.append(btnPicture4.imageForState(UIControlState.Normal)!)
            imagesArr.append(btnPicture5.imageForState(UIControlState.Normal)!)
        

        ProgressHUD.show("Uploading pictures...")
        
        var manager = ServiceManager()
            manager.signupWithFacebookId(settings.fbId,
                gender: settings.userGender,
                requiredGender: settings.userGender,
                fromAge:settings.userAgeFrom,
                toAge: settings.userAgeTo,
                distance: settings.userDistance,
                images: imagesArr,
                sucessBlock: { (isRegistered:Bool) -> Void in
                    println("isRegistered: \(isRegistered)")
                    ProgressHUD.showSuccess("Registered Successfully")
                    self.performSegueWithIdentifier("showMenuController", sender: nil)
                    
                }) { (error: NSError!) -> Void in
                    ProgressHUD.showSuccess("Registeration Failed")
                    println("error: \(error)")
            }

    }
    
    // MARK : - IBActions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        self.signup()
        
    }
    
    
    

    @IBAction func openImagePicker(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Button capture")
            
            var imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imgPicker.mediaTypes =  [kUTTypeImage as String]//[kUTTypeImage]
            imgPicker.allowsEditing = true
            
            self.presentViewController(imgPicker, animated: true, completion: nil)
            btnOpener = sender
        }
        
    }


    // MARK : - IMAGE PICKER DELEGATE METHODS

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in

            var img = info[UIImagePickerControllerEditedImage] as! UIImage //2
            self.btnOpener?.setImage(img, forState: UIControlState.Normal)
            self.btnOpener?.userInteractionEnabled = false
            
        })
    }

    
}