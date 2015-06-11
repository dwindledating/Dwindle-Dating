//
//  MatchChatController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/27/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

class MatchChatController: JSQMessagesViewController ,
    UIActionSheetDelegate,
    KDCycleBannerViewDataource,
    KDCycleBannerViewDelegate
    {
    
    @IBOutlet var imagesViewContainer : UIView!
    
    
    
    var socketIO     :SIOSocket?
    var demoData: DemoModelData!
    var galleryImages: Array<NSURL>!

    var playerMain : Player!
    var playerOpponent: Player!
    
    var toUserId: String!
    var toUserName: String!
    var status: String!
    
    @IBOutlet var scroller : KDCycleBannerView!

    
    @IBOutlet weak var galleryHeightConstraint : NSLayoutConstraint?

    
    func receiveMessagePressed(sender: UIBarButtonItem){
        
        
    }
    
    func addNavigationProfileButton(imgUrl:NSURL){
    
        
        var img = UIImage(named:"demo_avatar_jobs")!
        img = img.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        var btnProfileImg: RoundButtonView = RoundButtonView.buttonWithType(UIButtonType.Custom) as! RoundButtonView
        btnProfileImg.sd_setBackgroundImageWithURL(imgUrl, forState: UIControlState.Normal)
//        btnProfileImg.setImage(img, forState: UIControlState.Normal)
        btnProfileImg.addTarget(self, action: Selector("openImageGallery:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        var frame = btnProfileImg.frame
        frame.size = CGSizeMake(44, 44)
        btnProfileImg.frame = frame
        
        var barButton = UIBarButtonItem(customView: btnProfileImg)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ProgressHUD.dismiss()
        self.socketIO?.emit("loggedout")
        super.viewWillDisappear(animated)
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = NSUserDefaults.springinessSetting();
        self.startChat()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let userName = self.toUserName{
            self.title = self.toUserName
        }else
        {
            self.title = self.toUserId
        }
        
        

        
        
        /**
        *  You MUST set your senderId and display name
        */
        var settings = UserSettings.loadUserSettings()
        self.senderId = settings.fbId//kJSQDemoAvatarIdSquires;
        self.senderDisplayName = settings.fbName// kJSQDemoAvatarDisplayNameSquires;
        
        self.demoData = DemoModelData()
        
        if (!NSUserDefaults.incomingAvatarSetting()){
            self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        }
        
        if (!NSUserDefaults.outgoingAvatarSetting()) {
            self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        }
        
        self.showLoadEarlierMessagesHeader = true
        
        
        
        
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "demo_avatar_jobs"), style: UIBarButtonItemStyle.Bordered, target: self, action: "receiveMessagePressed:")
        
        
        self.jsq_configureMessagesViewController();
        self.jsq_registerForNotifications(true);
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Gallery Stuff

    // MARK : KDCycleBannerView DataSource
    func numberOfKDCycleBannerView(bannerView: KDCycleBannerView!) -> [AnyObject]! {
        
        var imagesList:AnyObject = []

        if var gallery = self.galleryImages{
            imagesList = (self.galleryImages as NSArray as? [NSURL])!
        }
        else{
            let imagesList   = [UIImage(named:"signup_01")!]
        }
        return imagesList as! [AnyObject]
    }
    
    func contentModeForImageIndex(index: UInt) -> UIViewContentMode {
        return UIViewContentMode.ScaleAspectFit;
    }

    
    // MARK:- SOCKETS
    
    func initSocketConnection(){
    
        
        SIOSocket.socketWithHost("http://52.11.98.82:3000/Chat", response: { (socket: SIOSocket!) -> Void in
            //code
            self.socketIO = socket 
            socket.on("connect", callback: { (args:[AnyObject]!) -> Void in
                //code
  
                println ("Connected");
                var settings = UserSettings.loadUserSettings()
                println("My FBID: \(settings.fbId) Wants to connect with :\(self.toUserId) with status: \(self.status)")
                
                socket.emit("chat", args: [settings.fbId,self.toUserId,self.status])
                ProgressHUD.show("Getting Chat History")
                
            })

            
            socket.on("getChatLog", callback: { (args:[AnyObject]!) -> Void in
                //code
                
                
                var response = args[0] as! String
                let data = response.dataUsingEncoding(NSUTF8StringEncoding)

                var err: NSError?
                var responseDict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                //SET CHAT
                var messages = responseDict["Chat"] as! [AnyObject]
                messages = messages.reverse()
                self.demoData.addMessages(messages)
                self.collectionView.reloadData()
                ProgressHUD.showSuccess("")
                self.scrollToBottomAnimated(true)
                //SET PICTURES

                var pictures = responseDict["Pictures"] as! NSDictionary
                self.galleryImages = []
                self.galleryImages.append(NSURL(string: (pictures["Picture1"] as? String)!)!)
                self.galleryImages.append(NSURL(string: (pictures["Picture2"] as? String)!)!)
                self.galleryImages.append(NSURL(string: (pictures["Picture3"] as? String)!)!)
                self.galleryImages.append(NSURL(string: (pictures["Picture4"] as? String)!)!)
                self.galleryImages.append(NSURL(string: (pictures["Picture5"] as? String)!)!)
                
                self.addNavigationProfileButton(self.galleryImages[0])

            })
            
            socket.on("updatechat", callback: { (args:[AnyObject]!) -> Void in
                //code
                println ("updatechat\(args)");
                
                var response = args as! Array<String>
//                let data = response.dataUsingEncoding(NSUTF8StringEncoding)
//                
//                var err: NSError?
//                let responseArr = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
//                if(err != nil) {
//                    println("JSON Error \(err!.localizedDescription)")
//                }

                var _senderId:String = ""
                if let tmpSenderId = response[0] as? String {
                    _senderId = tmpSenderId
                }
                var _message:String = (response[1] as? String)!

                if let tmpPlayerId = self.toUserId{
                    if (_senderId == self.toUserId){
                        self.receivedMessagePressed(_senderId, _displayName: "", _message: _message)
                    }
                }
            })
            
            socket.on("disconnect", callback: { (args:[AnyObject]!) -> Void in
                //code
                println ("disconnect\(args)");

            
            })
        })
        
    }
    
    func startChat(){
        
        ProgressHUD.show("Opening Chat...")
        self.initSocketConnection();
        
    }
    
    func sendChat(message:String){
        self.socketIO?.emit("sendchat", args:[message])
    }
    
    // MARK: - HANDLE UI - OpenGallery
    func hideKeyboard(){
        
        if(self.inputToolbar.contentView.textView.isFirstResponder()){
            self.inputToolbar.contentView.textView.resignFirstResponder()
        }
    }
    
    func openProfile(){
        
        println("openProfile")
        
    }
    
    @IBAction func openImageGallery(sender: AnyObject) {
        
        println("openImageGallery")
        
        self.hideKeyboard()
        
        var galleryOpenerButton = sender as? UIButton
        
        if (galleryOpenerButton!.tag == 0){
            galleryOpenerButton!.tag = 1
            galleryHeightConstraint!.constant = 275
        }
        else if (galleryOpenerButton!.tag == 1){
            galleryOpenerButton!.tag = 0
            galleryHeightConstraint!.constant = 0
        }
        
        
        UIView.animateWithDuration(0.5) {
            self.view.needsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
        
        scroller.reloadDataWithCompleteBlock { () -> Void in
            //code
        }
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -   JSQMessagesViewController method overrides
    
    
    func receivedMessagePressed(_senderId:String, _displayName:String, _message:String) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
        var newMessage : JSQMessage ;
        
        newMessage = JSQMessage(senderId: _senderId, displayName: _displayName, text: _message)
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        self.demoData.messages.addObject(newMessage)
        self.finishReceivingMessageAnimated(true)
        
    }
    
  
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        /**
        *  Sending a message. Your implementation of this method should do *at least* the following:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishSendingMessage`
        */
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        var message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        self.demoData.messages.addObject(message);
        
        self.finishSendingMessageAnimated(true);
        
        self.sendChat(text)
        
        
    }
    
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -  JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.demoData.messages[indexPath.item]as! JSQMessageData
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        /**
        *  You may return nil here if you do not want bubbles.
        *  In this case, you should set the background color of your collection view cell's textView.
        *
        *  Otherwise, return your previously created bubble image data objects.
        */
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        if (message.senderId == self.senderId) {
            return self.demoData.outgoingBubbleImageData;
        }
        
        return self.demoData.incomingBubbleImageData;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        /**
        *  Return `nil` here if you do not want avatars.
        *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        *
        *  It is possible to have only outgoing avatars or only incoming avatars, too.
        */
        
        /**
        *  Return your previously created avatar image data objects.
        *
        *  Note: these the avatars will be sized according to these values:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
        *
        *  Override the defaults in `viewDidLoad`
        */
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        
        if (message.senderId == self.senderId) {
            if (!NSUserDefaults.outgoingAvatarSetting()) {
                return nil;
            }
        }
        else {
            if (!NSUserDefaults.incomingAvatarSetting()) {
                return nil;
            }
        }
        
        return nil;
        //return self.demoData.avatars[message.senderId] as JSQMessageAvatarImageDataSource;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        /**
        *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
        *  The other label text delegate methods should follow a similar pattern.
        *
        *  Show a timestamp for every 3rd message
        */
        if (indexPath.item % 3 == 0) {
            var message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil;
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        
        /**
        *  iOS7-style sender name labels
        */
        if (message.senderId  == self.senderId) {
            return nil;
        }
        
        if (indexPath.item - 1 > 0) {
            var previousMessage: JSQMessage = self.demoData.messages[indexPath.item - 1] as! JSQMessage;
            if (previousMessage.senderId == message.senderId) {
                return nil;
            }
        }
        
        /**
        *  Don't specify attributes to use the defaults.
        */
        return NSAttributedString(string: message.senderDisplayName);
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        return nil;
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -  UICollectionView DataSource
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: NSInteger) -> NSInteger {
        return self.demoData.messages.count;
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        if let textView = cell.textView {
            var message = self.demoData.messages[indexPath.item] as! JSQMessage
            if message.senderId == self.senderId {
                textView.textColor = UIColor.whiteColor()
            } else {
                textView.textColor = UIColor.blackColor()
            }
            
            let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:textView.textColor, NSUnderlineStyleAttributeName: 1]
            textView.linkTextAttributes = attributes
            
            //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
            //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        }
        return cell
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: - JSQMessages collection view flow layout delegate
    // MARK: - Adjusting cell label heights
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
        */
        
        /**
        *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
        *  The other label height delegate methods should follow similarly
        *
        *  Show a timestamp for every 3rd message
        */
        
        if (indexPath.item % 3 == 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        
        return 0.0;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  iOS7-style sender name labels
        */
        
        var currentMessage :JSQMessage = self.demoData.messages[indexPath.item] as! JSQMessage;
        
        if (currentMessage.senderId == self.senderId) {
            return 0.0;
        }
        
        if (indexPath.item - 1 > 0) {
            var previousMessage :JSQMessage = self.demoData.messages[indexPath.item - 1] as! JSQMessage;
            if (previousMessage.senderId == currentMessage.senderId) {
                return 0.0;
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 0.0;
    }
    
    
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: - Responding to collection view tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        println("Load earlier messages!");
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        println("Tapped avatar!");
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        println("Tapped message bubble!");
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        println("Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
    }
    
    
    
}
