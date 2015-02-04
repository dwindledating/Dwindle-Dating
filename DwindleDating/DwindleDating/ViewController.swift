//
//  ViewController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/15/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class ViewController: UIViewController , FBLoginViewDelegate, KDCycleBannerViewDataource, KDCycleBannerViewDelegate {

    @IBOutlet var scroller : KDCycleBannerView!
    @IBOutlet var fbLoginView : FBLoginView!


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showSignup") {
            
            var signupVC = (segue.destinationViewController as SignupController)
            
            //Set Profile Image
            let urlPath: String = "YOUR_URL_HERE"
            var url: NSURL = NSURL(string: urlPath)!
            signupVC.userImgUrl = url
            
            
            //Set Welcome Message
            signupVC.userName = "Julia"
            
            
        }
    }
    func pushSignUpController(){
         performSegueWithIdentifier("showSignup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.fbLoginView.delegate = self
//        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]

        self.initContentView()
        var timer = NSTimer.scheduledTimerWithTimeInterval(2.1, target: self, selector: Selector("pushSignUpController"), userInfo: nil, repeats: false)
        
    }
    
    
    // MARK: - Scroller Stuff
    
    func initContentView(){
            scroller.autoPlayTimeInterval = 2;
            scroller.continuous = false;
        
    }

    

    
    // MARK : KDCycleBannerView DELEGATE
    func placeHolderImageOfBannerView(bannerView: KDCycleBannerView!, atIndex index: UInt) -> UIImage! {
        let img = UIImage(named:"image1.png")!
        return img
    }
    
    func placeHolderImageOfZeroBannerView() -> UIImage! {
        let img = UIImage(named:"image1.png")!
        return img
    }
    
    
    // MARK : KDCycleBannerView DataSource
    func numberOfKDCycleBannerView(bannerView: KDCycleBannerView!) -> [AnyObject]! {
        let imagesList   = [UIImage(named:"signup_01")!,
                            UIImage(named:"signup_02")!,
                            UIImage(named:"signup_03")!,
                            UIImage(named:"signup_04")!]
        
        return imagesList
    }
    
    
    func contentModeForImageIndex(index: UInt) -> UIViewContentMode {
        return UIViewContentMode.ScaleAspectFit;
    }
    
    

    
    
    
    
    
    
    // MARK: - your text goes here
    
    // Facebook Delegate Methods
    func fbDialogLogin(tokenstr: String! ,  expirationDate: NSDate){
         println("User: \(tokenstr)")
    }

    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        //fbLoginView.alpha = 0
        
        var accessToken = FBSession.activeSession().accessTokenData.accessToken
        println("token: \(accessToken)")
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
