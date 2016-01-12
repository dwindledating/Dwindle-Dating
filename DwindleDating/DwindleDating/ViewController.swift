//
//  ViewController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/15/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit
import Parse

class ViewController: BaseController , FBLoginViewDelegate, KDCycleBannerViewDataource, KDCycleBannerViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet var scroller : KDCycleBannerView!
    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var txtViewPrivacy : UITextView!
    
    var cachedUserId : String!
    
    func shouldSetupUser() -> Bool{
        var status:  Bool = false
        
        if let currentUser = PFUser.currentUser() {
            // Do stuff with the user
            print("PFUserId => \(currentUser.username)")
        } else {
            // Show the signup or login screen
            status = true
        }
        
        return status
    }
    
    func setupUser() {
        
        if (self.shouldSetupUser()){

            let settings = UserSettings.loadUserSettings()
            
            PFUser.logInWithUsernameInBackground(settings.fbId, password:settings.fbId) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock({ (status:Bool, error:NSError?) -> Void in
                        //code
                        if let error = error {
                            let errorString = error.userInfo["error"] as? NSString
                            print("Error in Login : \(errorString)")
                            // Show the errorString somewhere and let the user try again.
                        } else {
                            // Hooray! Let them use the app now.
                            print("Hooray! Logged in now.")
                        }
                    })
                    
                } else {
                    // The login failed. Check error to see why.
                    let userMain = PFUser()
                    userMain.username = settings.fbId
                    userMain.password = settings.fbId
                    
                    // other fields can be set just like with PFObject
                    userMain["fullName"] = settings.fbName
                    userMain.signUpInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if let error = error {
                            let errorString = error.userInfo["error"] as? NSString
                            print("Error : \(errorString)")
                            // Show the errorString somewhere and let the user try again.
                        } else {
                            // Hooray! Let them use the app now.
                            print("Hooray! Let them use the app now.")
                            
                            let installation = PFInstallation.currentInstallation()
                            installation["user"] = PFUser.currentUser()
                            installation.saveInBackgroundWithBlock({ (status:Bool, error:NSError?) -> Void in
                                //code
                            })
                        }
                    }
                }
            }
            

        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.setupUser()
        
        if(segue.identifier == "showSignup") {
            
            let signupVC = segue.destinationViewController as! SignupController
            
            //Set Profile Image
            let urlPath: String = "http://graph.facebook.com/" + UserSettings.loadUserSettings().fbId + "/picture?type=large"
            let url: NSURL = NSURL(string: urlPath)!
            signupVC.userImgUrl = url
            
            //Set Welcome Message
            signupVC.userName = UserSettings.loadUserSettings().fbName
        }
    }
    
    func signIn(fbId: String){

        print(" ========================= ")
        print(" =======Signing IN======== ")
        print(" ========================= ")

//        self.pushSignUpController()
//        self.pushMenuController()
//        return

        ProgressHUD.show("Signing in...")

        let manager = ServiceManager()

        manager.loginWithFacebookId(fbId, sucessBlock:{ (isRegistered:Bool) -> Void in
            print("isRegistered: \(isRegistered)")

            self.cachedUserId = nil
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
              print("error: \(error)")
            self.fbLoginView.hidden = false
            ProgressHUD.showError("\(error.localizedDescription)")
        }
    }
    
    func pushSignUpController(){
         performSegueWithIdentifier("showSignup", sender: nil)
    }
    
    func pushMenuController(){
        performSegueWithIdentifier("showMenu", sender: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initContentView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)

        self.fbLoginView.delegate = self
//        self.fbLoginView.readPermissions = ["basic_info","public_profile", "email", "user_friends", "user_birthday"]
        
        self.fbLoginView.readPermissions = ["email","public_profile","user_birthday"]
        
        txtViewPrivacy.editable = true
        txtViewPrivacy.textColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1)
        txtViewPrivacy.font = UIFont(name: "Gadugi", size: 12.0)
        txtViewPrivacy.editable = false
        txtViewPrivacy.backgroundColor = UIColor.clearColor()
    }
    
    func initContentView(){
        // Scroll Initialization
            scroller.autoPlayTimeInterval = 4;
            scroller.continuous = true;
        
        //Add gesture
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "textTapped:")
        txtViewPrivacy.addGestureRecognizer(tapGesture)
    
        let paragraph = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        let myfont: UIFont? = txtViewPrivacy.font
        
        let textviewAttrString = NSMutableAttributedString()
        textviewAttrString.appendAttributedString(txtViewPrivacy.attributedText)
        textviewAttrString.addAttribute(NSFontAttributeName, value:myfont!, range: NSRange(location: 0, length: textviewAttrString.length))
        let termsDict: Dictionary<String, AnyObject> = [
            "termsTag": true,
            "NSUnderline": 1
        ]
        let termsString     = NSAttributedString(string: "Terms and Conditions", attributes: termsDict)

        let privacyDict: Dictionary<String, AnyObject> = [
            "privacyTag": true,
            "NSUnderline": 1
        ]
        let privacyString   = NSAttributedString(string:"Privacy Policy",attributes: privacyDict)
        
        let range0: NSRange = (textviewAttrString.string as NSString).rangeOfString("{0}")
        if(range0.location != NSNotFound){
            textviewAttrString.replaceCharactersInRange(range0, withAttributedString: termsString)
        }

        let range1: NSRange = (textviewAttrString.string as NSString).rangeOfString("{1}")
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
            print(charIndex)

            var range = NSRange(location: 0, length: 98)

            var influenceAttributes:NSDictionary?
            influenceAttributes  = textView!.attributedText?.attributesAtIndex(charIndex, effectiveRange: &range)
            if let privacyTag: AnyObject = influenceAttributes?["privacyTag"] {
                self.performSegueWithIdentifier("showPrivacyPolicyController", sender: self)                
                print("Privacy tag it is \(privacyTag)")
                
            }
            else if let termsTag: AnyObject = influenceAttributes?["termsTag"] {
                print("Terms tag it is \(termsTag)")
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
        return UIViewContentMode.ScaleToFill;
    }
    
    // MARK : KDCycleBannerView Delegate
    
    func cycleBannerView(bannerView: KDCycleBannerView!, didScrollToIndex index: UInt) {
        updateTitleOnBannerChange(index)
    }
    
    var currentIndex:UInt = 4
    func updateTitleOnBannerChange(index:UInt) {
        
        if currentIndex != index {
            currentIndex = index
        }
        else {
            print("didScrollToIndex: \(index)")
            return
        }
        
        var title = ""
        var description = ""
        
        switch currentIndex {
        case 0:
            title = "Personality Comes First"
            description = "Start a Dwindle Date based on your preferences. Your match is unknown, but one of five photos shown."
            break
        case 1:
            title = "Make Them Fall For You"
            description = "Have a real conversation and photos will Dwindle Down as your chat progresses, bringing you a step closer to your match."
            break
        case 2:
            title = "Keep It Up & See More"
            description = "Additional photos are unlocked for those that remain after each Dwindle Down."
            break
        case 3:
            title = "Meet Your Match!"
            description = "Make it to the end and your true identities will be revealed. Keep chatting anytime through the Dwindle Dating app."
            break
        default: break
            
        }
        lblTitle.text = title
        lbldescription.text = description
    }
    
    // MARK: - your text goes here
    
    // Facebook Delegate Methods
    func fbDialogLogin(tokenstr: String! ,  expirationDate: NSDate){
         print("User: \(tokenstr)")
    }

    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        print("User Logged In")
        fbLoginView.hidden = true
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        //fbLoginView.alpha = 0
        
        if let cachedId = cachedUserId where cachedId == user.objectID {
                return;
        }
        else{
            // cacheId is nil
        }
        
        //        FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection: FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            
//            print("result  => \(result)")
//            //code
//        })
        
        
        cachedUserId = user.objectID
        
        let userSettings = UserSettings.loadUserSettings() as UserSettings
        
        userSettings.userGender    = "F"

        let gender = user.objectForKey("gender") as! String
        if (gender == "male"){
            userSettings.userGender    = "M"
        }
        
        if let birthday = user.objectForKey("birthday")as? String{
            
            var dob = birthday.componentsSeparatedByString("/")
            
            userSettings.userBirthday = "\(dob[2])\(dob[1])\(dob[0])"
        }
        else{
            userSettings.userBirthday    = "19900101"
        }

        let accessToken = FBSession.activeSession().accessTokenData.accessToken
        
        print(accessToken)
        
        if TARGET_OS_SIMULATOR == 1 { // it is female
            userSettings.fbId    = "696284960499030"
            userSettings.fbName  = "Aneesa Bhatti"
        }
        else {
            userSettings.fbName  = user.name
            userSettings.fbId    = "10153221085360955" //"1427619287531895"
        }
        
//        userSettings.fbId    = user.objectID
//        userSettings.fbName  = user.name
        userSettings.saveUserSettings()
        
        self.signIn(userSettings.fbId)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        print("User Logged Out")
        fbLoginView.hidden = false
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        print("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
