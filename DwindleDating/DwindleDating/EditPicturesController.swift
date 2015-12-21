//
//  EditPicturesController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation
import MobileCoreServices



class EditPicturesController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var btnPicture1       :   RoundButtonView!
    @IBOutlet var btnPicture2       :   RoundButtonView!
    @IBOutlet var btnPicture3       :   RoundButtonView!
    @IBOutlet var btnPicture4       :   RoundButtonView!
    @IBOutlet var btnPicture5       :   RoundButtonView!

    
    var userPicturesDict : NSDictionary!
    var btnOpener : UIButton?
    
    
    func getUserPictures(){
        
        ProgressHUD.show("Loading pictures...")
        let settings = UserSettings.loadUserSettings()
        let manager = ServiceManager()
        manager.getUserPicturesAgainstFacebookId(settings.fbId,  sucessBlock: { (pictures:[NSObject: AnyObject]!) -> Void in
        
            ProgressHUD.dismiss()
            
            let data:NSDictionary = pictures as NSDictionary
            self.userPicturesDict = data
            print("pictures \(data)")
            
            let url1: NSURL = NSURL(string: (data["Pic1 Path"] as? String)!)!
            let url2: NSURL = NSURL(string: (data["Pic2 Path"] as? String)!)!
            let url3: NSURL = NSURL(string: (data["Pic3 Path"] as? String)!)!
            let url4: NSURL = NSURL(string: (data["Pic4 Path"] as? String)!)!
            let url5: NSURL = NSURL(string: (data["Pic5 Path"] as? String)!)!
            
            self.btnPicture1.sd_setImageWithURL(url1 , forState: .Normal)
            self.btnPicture2.sd_setImageWithURL(url2 , forState: .Normal)
            self.btnPicture3.sd_setImageWithURL(url3 , forState: .Normal)
            self.btnPicture4.sd_setImageWithURL(url4 , forState: .Normal)
            self.btnPicture5.sd_setImageWithURL(url5 , forState: .Normal)
            
//            self.btnPicture1.sd_setImageWithURL(url1, forState: UIControlState.Normal, placeholderImage: nil, options: SDWebImageOptions.ProgressiveDownload)
            
            }) { (error:NSError!) -> Void in
            ProgressHUD.showError("Loading Failed")
        }
    }
    
    func initContentView(){
        
        self.btnPicture1.borderWidth = 3.0;
        self.btnPicture2.borderWidth = 3.0;
        self.btnPicture3.borderWidth = 3.0;
        self.btnPicture4.borderWidth = 3.0;
        self.btnPicture5.borderWidth = 3.0;
        
        self.getUserPictures()
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    
    func updatePicture (){

        
        var picName:String = "";
        var picUrl : String = "";
        
        if(self.btnPicture1.isEqual(btnOpener)){
            picName = userPicturesDict["Pic1 Name"] as! String
            picUrl  = userPicturesDict["Pic1 Path"] as! String
        }
        else if (self.btnPicture2.isEqual(btnOpener)){
            picName = userPicturesDict["Pic2 Name"] as! String
            picUrl  = userPicturesDict["Pic2 Path"] as! String
        }
        else if (self.btnPicture3.isEqual(btnOpener)){
            picName = userPicturesDict["Pic3 Name"] as! String
            picUrl  = userPicturesDict["Pic3 Path"] as! String
        }
        else if (self.btnPicture4.isEqual(btnOpener)){
            picName = userPicturesDict["Pic4 Name"] as! String
            picUrl  = userPicturesDict["Pic4 Path"] as! String
        }
        else if (self.btnPicture5.isEqual(btnOpener)){
            picName = userPicturesDict["Pic5 Name"] as! String
            picUrl  = userPicturesDict["Pic5 Path"] as! String
        }
        
        SDImageCache.sharedImageCache().removeImageForKey(picUrl, fromDisk: true)
        let settings = UserSettings.loadUserSettings()
        
        var imagesArr = [UIImage]()
        
        imagesArr.append(self.btnOpener!.imageForState(UIControlState.Normal)!)
        
        
        ProgressHUD.show("Updating picture")
        
        let manager = ServiceManager()
        
        manager.updateUserPictureAgainstFacebookId(settings.fbId, andPictureName: picName, withImage: imagesArr, sucessBlock: { (isUpdated:Bool) -> Void in
            print("isUpdated: \(isUpdated)")
            ProgressHUD.showSuccess("Updated Successfully")
            
            }) { (error: NSError!) -> Void in
                ProgressHUD.showError("Update Failed")
                print("error: \(error)")
        }

    }
    
    // MARK : - IBActions
    
//    @IBAction func nextButtonPressed(sender: UIButton) {
//        
//        self.signup()
//        
//    }
    
    @IBAction func openImagePicker(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("Button capture")
            
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imgPicker.mediaTypes =  [kUTTypeImage as String]//[kUTTypeImage]
            imgPicker.allowsEditing = true
            
            self.presentViewController(imgPicker, animated: true, completion: nil)
            btnOpener = sender
        }
        
    }
    
    // MARK : - IMAGE PICKER DELEGATE METHODS
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            let img = info[UIImagePickerControllerEditedImage] as! UIImage //2
            self.btnOpener?.setImage(img, forState: UIControlState.Normal)
//            self.btnOpener?.userInteractionEnabled = false
            self.updatePicture()
        })
    }
    
    
}