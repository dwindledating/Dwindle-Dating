//
//  SignupController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

class SignupController: UIViewController  {
    
    @IBOutlet var imgViewProfile : UIImageView!
    @IBOutlet var lblWelcometxt : UILabel!
    @IBOutlet var btnNext       : UIButton!
    
    var userImgUrl: NSURL!
    var userName: String!
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier("showGenderSelector", sender: nil)
    
    }
    
    
    func initContentView(){
       
        
        var attrsWelcomeTxt =   [NSFontAttributeName : UIFont.systemFontOfSize(14.0),
            NSForegroundColorAttributeName: UIColor.blackColor()]
        
        let welcomeText = "Lets get started,\n"
        var welcomeMsgAttributed = NSMutableAttributedString(string: welcomeText, attributes: attrsWelcomeTxt)
        
        let username = userName + " ! "
        var attrsName = [NSForegroundColorAttributeName: UIColor.purpleColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        
        let gString = NSMutableAttributedString(string: username, attributes:attrsName)
        
        welcomeMsgAttributed.appendAttributedString(gString)

        lblWelcometxt.attributedText = welcomeMsgAttributed

        
        
        
        let img = UIImage(named:"image1.png")!
        imgViewProfile.sd_setImageWithURL(userImgUrl,
                                        placeholderImage: img,
                                        options:SDWebImageOptions.ContinueInBackground)

        imgViewProfile.contentMode = UIViewContentMode.ScaleAspectFill
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.width/2.0;
        imgViewProfile.layer.borderColor = UIColor.redColor().CGColor
        imgViewProfile.layer.borderWidth = 5.0;
        imgViewProfile.layer.masksToBounds = true
     
        println(NSStringFromCGRect(imgViewProfile.bounds))
        println(NSStringFromCGRect(imgViewProfile.frame))
        
        btnNext.layer.cornerRadius = 5.0
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
}


