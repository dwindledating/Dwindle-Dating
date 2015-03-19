//
//  GamePlayController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/27/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class GamePlayController: JSQMessagesViewController , UIActionSheetDelegate {
    
    
    @IBOutlet var imagesViewContainer : UIView!
    
    
    var demoData: DemoModelData!
    
    func receiveMessagePressed(sender: UIBarButtonItem){
        
        
    }
    
    func closePressed(sender: UIBarButtonItem){
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = NSUserDefaults.springinessSetting();
//        self.resizeCollectionView(50)
        //        self.view.addSubview(imagesViewContainer)
//        var myView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)) as UIView
//        myView.backgroundColor = UIColor.redColor()
//        self.view.addSubview(myView)
        //        self.view.addSubview(imagesViewContainer)
        //        self.view.bringSubviewToFront(imagesViewContainer)
        //        println(imagesViewContainer)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Chat Controller"
        
        
        /**
        *  You MUST set your senderId and display name
        */
        self.senderId = "053496-4509-289"//kJSQDemoAvatarIdSquires;
        self.senderDisplayName = "Jesse Squires"// kJSQDemoAvatarDisplayNameSquires;
        
        self.demoData = DemoModelData()
        
        if (!NSUserDefaults.incomingAvatarSetting()){
            self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        }
        
        if (!NSUserDefaults.outgoingAvatarSetting()) {
            self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        }
        
        self.showLoadEarlierMessagesHeader = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicatorImage(), style: UIBarButtonItemStyle.Bordered, target: self, action: "receiveMessagePressed:")
        
        
        self.jsq_configureMessagesViewController();
        self.jsq_registerForNotifications(true);
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -   Actions
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -   JSQMessagesViewController method overrides
    
    
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
        
    }
    
    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        
        var sheet = UIActionSheet(title: "Media messages", delegate:self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send photo", "Send message");
        
        //    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
        //    delegate:self
        //    cancelButtonTitle:@"Cancel"
        //    destructiveButtonTitle:nil
        //    otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
        sheet.showFromToolbar(self.inputToolbar);
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        switch (buttonIndex) {
        case 1:
            self.demoData.addPhotoMediaMessage();
            break;
            
        case 2:
            self.demoData.sendTextMessage();
            //var weakView = self.collectionView as UICollectionView;
            //self.demoData.addLocationMediaMessageCompletion({ () -> Void in
             //   weakView.reloadData();
            //});
            
            break;
            
//        case 3:
//            self.demoData.addVideoMediaMessage();
//            break;
            
        default:
            
            break;
            
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        self.finishSendingMessageAnimated(true);
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -  JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.demoData.messages[indexPath.item] as JSQMessageData
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        /**
        *  You may return nil here if you do not want bubbles.
        *  In this case, you should set the background color of your collection view cell's textView.
        *
        *  Otherwise, return your previously created bubble image data objects.
        */
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as JSQMessage
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
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as JSQMessage
        
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
            var message : JSQMessage = self.demoData.messages [indexPath.item] as JSQMessage
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil;
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        var message : JSQMessage = self.demoData.messages [indexPath.item] as JSQMessage
        
        /**
        *  iOS7-style sender name labels
        */
        if (message.senderId  == self.senderId) {
            return nil;
        }
        
        if (indexPath.item - 1 > 0) {
            var previousMessage: JSQMessage = self.demoData.messages[indexPath.item - 1] as JSQMessage;
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
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        if let textView = cell.textView {
            var message = self.demoData.messages[indexPath.item] as JSQMessage
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
        
        var currentMessage :JSQMessage = self.demoData.messages[indexPath.item] as JSQMessage;
        
        if (currentMessage.senderId == self.senderId) {
            return 0.0;
        }
        
        if (indexPath.item - 1 > 0) {
            var previousMessage :JSQMessage = self.demoData.messages[indexPath.item - 1] as JSQMessage;
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

