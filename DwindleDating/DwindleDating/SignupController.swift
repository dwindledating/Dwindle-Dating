//
//  SignupController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

class SignupController: BaseViewController  {
    
    @IBOutlet var imgViewProfile : RoundImageView!
    @IBOutlet var lblWelcometxt : UILabel!
    @IBOutlet var btnNext       : UIButton!
    
    var userImgUrl: NSURL!
    var userName: String!
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier("showGenderSelector", sender: nil)
    
    }
    
    
    func initContentView(){
    
        
        self.navigationItem.title = "Sign Up"
        
        let font:UIFont? = UIFont(name: "HelveticaNeue-CondensedBold", size: 18.0)
        
        
        let attrsWelcomeTxt =   [NSFontAttributeName : font!,
            NSForegroundColorAttributeName: UIColor(red: 0.0/255.0, green: 149.0/255.0, blue: 191.0/255.0, alpha: 1.0)]
        
        let welcomeText = "\nWhat's cookin', good lookin'?"
        let welcomeMsgAttributed = NSMutableAttributedString(string: welcomeText, attributes: attrsWelcomeTxt)
        

//        userName = "TEST"
        let username = userName + ""
        let attrsName = [NSForegroundColorAttributeName: UIColor(red: 253.0/255.0, green: 0.0/255.0, blue: 80.0/255.0, alpha: 1.0),
            NSFontAttributeName : font!]
        
        let gString = NSMutableAttributedString(string: username, attributes:attrsName)
        
        gString.appendAttributedString(welcomeMsgAttributed)

        lblWelcometxt.attributedText = gString

        let img = UIImage(named:"matches")!
        imgViewProfile.borderWidth = 5.0
        imgViewProfile.sd_setImageWithURL(userImgUrl,
                                        placeholderImage: img,
                                        options:SDWebImageOptions.ContinueInBackground)

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


