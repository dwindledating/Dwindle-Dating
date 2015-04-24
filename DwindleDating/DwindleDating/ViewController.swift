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
    @IBOutlet var txtViewPrivacy : UITextView!
    
    var cachedUserId : String!


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showSignup") {
            
            var signupVC = (segue.destinationViewController as! SignupController)
            
            //Set Profile Image
            let urlPath: String = "http://graph.facebook.com/"  + UserSettings.loadUserSettings().fbId + "/picture?type=large"
            var url: NSURL = NSURL(string: urlPath)!
            signupVC.userImgUrl = url
            
            //Set Welcome Message
            signupVC.userName = UserSettings.loadUserSettings().fbName
            
            
        }
    }
    
    
    func signIn(fbId: String){

        println(" ========================= ")
        println(" =======Signing IN======== ")
        println(" ========================= ")

//        self.pushSignUpController()
        self.pushMenuController()
        return

//        ProgressHUD.show("Signing in...")

        var manager = ServiceManager()

        manager.loginWithFacebookId(fbId, sucessBlock:{ (isRegistered:Bool) -> Void in
            println("isRegistered: \(isRegistered)")

            if (isRegistered){
                self.pushMenuController()
//                 self.pushSignUpController()
                ProgressHUD.dismiss()
            }
            else{
                self.pushSignUpController()
                ProgressHUD.dismiss()
            }
            
        }) { (error: NSError!) -> Void in
              println("error: \(error)")
        }

        
        
    }
    
    func pushSignUpController(){
         performSegueWithIdentifier("showSignup", sender: nil)
    }
    
    func pushMenuController(){
        performSegueWithIdentifier("showMenu", sender: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)

        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]

        txtViewPrivacy.editable = true
        txtViewPrivacy.textColor = UIColor(red: 38/255.0, green: 182/255.0, blue: 218/255.0, alpha: 1.0)
        txtViewPrivacy.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 11.0)
        txtViewPrivacy.editable = false
        txtViewPrivacy.backgroundColor = UIColor.clearColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initContentView()
    }
    
    

    
    func initContentView(){
        // Scroll Initialization
            scroller.autoPlayTimeInterval = 2;
            scroller.continuous = false;
        
        //Add gesture
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "textTapped:")
        txtViewPrivacy.addGestureRecognizer(tapGesture)
    
        let paragraph = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        let myfont: UIFont? = txtViewPrivacy.font
        
        let textviewAttrString = NSMutableAttributedString()
        textviewAttrString.appendAttributedString(txtViewPrivacy.attributedText)
        textviewAttrString.addAttribute(NSFontAttributeName, value:myfont!, range: NSRange(location: 0, length: textviewAttrString.length))
        var termsDict: Dictionary<String, AnyObject> = [
            "termsTag": true,
            "NSUnderline": 1
        ]
        let termsString     = NSAttributedString(string: "Terms and Conditions", attributes: termsDict)

        var privacyDict: Dictionary<String, AnyObject> = [
            "privacyTag": true,
            "NSUnderline": 1
        ]
        let privacyString   = NSAttributedString(string:"Privacy Policy",attributes: privacyDict)
        

        
        var range0: NSRange = (textviewAttrString.string as NSString).rangeOfString("{0}")
        if(range0.location != NSNotFound){
            textviewAttrString.replaceCharactersInRange(range0, withAttributedString: termsString)
        }

        var range1: NSRange = (textviewAttrString.string as NSString).rangeOfString("{1}")
        if(range1.location != NSNotFound){
            textviewAttrString.replaceCharactersInRange(range1, withAttributedString: privacyString)
        }
        
        txtViewPrivacy!.attributedText = textviewAttrString
        txtViewPrivacy!.selectable = false
    }

    
    // MARK: - Privacy & TOC Handler
    
    func textTapped(recognizer: UITapGestureRecognizer) {
     
        let textView = recognizer.view as? UITextView
        
        let layoutManager: NSLayoutManager =    textView!.layoutManager
        var location: CGPoint = recognizer.locationInView(textView)
        location.x -= textView!.textContainerInset.left
        location.y -= textView!.textContainerInset.top

        // Find the character that's been tapped on
        var charIndex: Int
        charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView!.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if charIndex < textView!.textStorage.length {
            println(charIndex)

            var range = NSRange(location: 0, length: 98)

            var influenceAttributes:NSDictionary?
            influenceAttributes  = textView!.attributedText?.attributesAtIndex(charIndex, effectiveRange: &range)
            if let privacyTag: AnyObject = influenceAttributes?["privacyTag"] {
                self.performSegueWithIdentifier("showPrivacyPolicyController", sender: self)                
                println("Privacy tag it is")
                
            }
            else if let termsTag: AnyObject = influenceAttributes?["termsTag"] {
                println("Terms tag it is")
                self.performSegueWithIdentifier("showTermsController", sender: self)
            }
            
        }
        
    }
    
    // MARK: - Scroller Stuff - KDCycleBannerView DELEGATE
    
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
        fbLoginView.hidden = true
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        //fbLoginView.alpha = 0
        
        if var cachedId = cachedUserId{
            if (cachedUserId == user.objectID){
                return;
            }
        }
        else{
            // cacheId is nil
        }
        
        
        
        cachedUserId = user.objectID
        var userSettings = UserSettings.loadUserSettings() as UserSettings

        
        var accessToken = FBSession.activeSession().accessTokenData.accessToken
        
        userSettings.fbId    = user.objectID
        userSettings.fbName  = user.name
        userSettings.saveUserSettings()
        
        self.signIn(userSettings.fbId)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
        fbLoginView.hidden = false
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
