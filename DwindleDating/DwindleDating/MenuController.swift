//
//  MenuController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit
import MessageUI


class MenuController: BaseController ,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate {
    
    let dwindleSocket = DwindleSocketClient.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true)
        
        if self.dwindleSocket.status() == .Connected {
            let settings = UserSettings.loadUserSettings()
            self.dwindleSocket.sendEvent("event_change_user_status", data: [settings.fbId, "loggedin"])
        }
        
        if dwindleSocket.isMenuControllerHandlerAdded == true {
            print("isMenuControllerHandlerAdded:We do not need to add handler again. This may be creating socket again. Without closing ealier one.")
            return
        }
        
        dwindleSocket.EventHandler(HandlerType.Menu) { (socketClient: SocketIOClient) -> Void in
        
            socketClient.on("connect", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                
                let settings = UserSettings.loadUserSettings()
                self.dwindleSocket.sendEvent("event_change_user_status", data: [settings.fbId, "loggedin"])
                
                self.connectWithNetwork(false)
                
                // User got event from one of his match.
                socketClient.on("message_from_matches_screen", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print ("message_from_matches_screen: \(data)");
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let message = data[0] as! String
                        
                        AJNotificationView.showNoticeInView(AppDelegate.sharedAppDelegat().window!, type: AJNotificationTypeOrange, title: message, linedBackground: AJLinedBackgroundTypeAnimated, hideAfter: 2.0, response: { () -> Void in
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.navigationController?.setNavigationBarHidden(false, animated: false)
                                
                                let matchControler = AppDelegate.sharedAppDelegat().matchChatController
                                matchControler.isComingFromPlayScreen = true
                                matchControler.toUserId = data[1] as! String
                                matchControler.toUserName = data[3] as! String
                                matchControler.status = data[4] as! String
                                self.pushControllerInStack(matchControler, animated: true)
                            })
                        })
                    })
                })
                
                // User got play event from other user. This could be an in app push message as well.
                socketClient.on("message_from_play_screen", callback: { (data:[AnyObject], ac:SocketAckEmitter) -> Void in
                    
                    print ("message_from_play_screen: \(data)");
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let message = data[0] as! String
                        
                        AJNotificationView.showNoticeInView(AppDelegate.sharedAppDelegat().window!, type: AJNotificationTypeOrange, title: message, linedBackground: AJLinedBackgroundTypeAnimated, hideAfter: 2.0, response: { () -> Void in
                
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let playController = AppDelegate.sharedAppDelegat().playController
                                playController.isComingFromOtherScreen = true
                                self.pushControllerInStack(playController, animated: true)
                            })
                        })
                    })
                })
                
                // User has made a play request but switched screen.
                socketClient.on("startgame", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    let playController = AppDelegate.sharedAppDelegat().playController
                    playController.gameInProgress = true
                    
                    let dataStr: String = data[0] as! String
                    
                    let roomUserInfoDict: AnyObject =  playController.JSONParseDictionary(dataStr)
                    let roomName:String = (roomUserInfoDict["RoomName"] as? String)!
                    
                    print("\n RoomName ==>  \(roomName)")
                    
                    let secondUserDict = roomUserInfoDict["SecondUser"] as! NSDictionary
                    let secondUserFbId = secondUserDict["fb_id"] as! String
                    let settings = UserSettings.loadUserSettings()
                    
                    self.dwindleSocket.sendEvent("addUser", data: [roomName, settings.fbId, secondUserFbId])
                    self.dwindleSocket.sendEvent("event_change_isPlaying_flag", data: [settings.fbId, 1])
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        if self.navigationController?.topViewController?.nameOfClass != GamePlayController.nameOfClass {
                            
                            self.pushControllerInStack(playController, animated: true)
                            
                            let delay = 0.5 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                playController.gameStartedWithParams(dataStr)
                            }
                        }
                        else {
                            playController.gameStartedWithParams(dataStr)
                        }
                    })
                })
                
                socketClient.onAny({ (SocketAnyEvent) -> Void in
                    
                    if SocketAnyEvent.event == "error" {
                        print("MenuController->Error \(SocketAnyEvent.items)")
                    }
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectWithNetwork(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func connectWithNetwork(connect:Bool) {
        
        if connect {
            ProgressHUD.show("Connecting to network...", interaction: false)
        }
        else {
            ProgressHUD.dismiss()
        }
    }
    
    // MARK : - IBActions
    
    @IBAction func settingButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showSettingsController", sender: nil)
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {

        let playController = AppDelegate.sharedAppDelegat().playController
        playController.isComingFromOtherScreen = false
        self.pushControllerInStack(playController, animated: true)
    }
    
    @IBAction func matchButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("showMatchListController", sender: nil)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
   
        let sheet = UIActionSheet(title: "Share via", delegate:self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Message", "Email");
        sheet.showFromRect(sender.frame, inView: self.view, animated: true)
        
//        sheet.showFromToolbar(self.inputToolbar);
    }
    
    // MARK :- SMS STUFF
    
    func performSMSAction(){
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = [""]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    // MARK :- EMAIL STUFF
    
    func performEmailAction(){
        let emailTitle = "Dwindle Dating"//NSLocalizedString("aboutus_email_subject", comment: "Contact Us")
        let messageBody = "Hi, I would like to..."//NSLocalizedString("aboutus_email_message", comment: "Hi, I would like to...")
//        let toRecipents = [""]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        if (MFMailComposeViewController.canSendMail()) {
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
          //  mc.setToRecipients(toRecipents)
            
            self.presentViewController(mc, animated: true, completion: nil)
        }

    }
        
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result:
        MFMailComposeResult, error: NSError?) {
            switch result.rawValue {
            case MFMailComposeResultCancelled.rawValue:
                NSLog("Mail cancelled")
            case MFMailComposeResultSaved.rawValue:
                UIAlertView(title: "", message: NSLocalizedString("email_saved", comment: "The composition of this email has been saved.") , delegate: nil, cancelButtonTitle: NSLocalizedString("email_cancelbtn", comment: "Ok")).show()
            case MFMailComposeResultSent.rawValue:
                UIAlertView(title: "", message: NSLocalizedString("email_sent", comment: "The composition of this email has been sent."), delegate: nil, cancelButtonTitle: NSLocalizedString("email_cancelbtn", comment: "Ok")).show()
            case MFMailComposeResultFailed.rawValue:
                UIAlertView(title: "", message: NSLocalizedString("email_notsent", comment: "Mail sent failure")+": \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: NSLocalizedString("email_cancelbtn", comment: "Ok")).show()
                NSLog("Mail sent failure: %@", [error!.localizedDescription])
            default:
                break
            }
            self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        switch (buttonIndex) {
        case 0:
            //cancel
            print("0")
            
            break;
            
        case 1:
            //email
                print("1")
                self.performSMSAction()
            break;
            
        case 2:
            //Email
            self.performEmailAction()
            
            break;
            
        default:
            
            break;
        }
        
//        JSQSystemSoundPlayer.jsq_playMessageSentSound();
//        self.finishSendingMessageAnimated(true);
    }
    
}