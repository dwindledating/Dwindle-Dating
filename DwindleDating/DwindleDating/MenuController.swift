//
//  MenuController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit
import MessageUI

let kStr_MessageBody:String = "You gotta try this new dating app Dwindle! http://apple.co/1UXDO4e"

class MenuController: BaseViewController ,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate {
    
    private var popup: Popup? = nil
    private var playRequestTimer: NSTimer? = nil
    let dwindleSocket = DwindleSocketClient.sharedInstance
    
    func hidePlayRequestAlert(timer:NSTimer?) {
        
//        self.dismissViewControllerAnimated(true, completion: nil)
        popup?.removeFromSuperview()
        self.playRequestTimer?.invalidate()
        self.playRequestTimer = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true)
        
        connectWithNetwork(true)
        
        if dwindleSocket.isMenuControllerHandlerAdded == true {
            print("isMenuControllerHandlerAdded:We do not need to add handler again. This may be creating socket again. Without closing ealier one.")
            return
        }
        
        dwindleSocket.EventHandler(HandlerType.Menu) { (socketClient: SocketIOClient) -> Void in
        
            socketClient.on("connect", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                
                let settings = UserSettings.loadUserSettings()
                self.dwindleSocket.sendEvent("event_change_user_status", data: [settings.fbId, "loggedin"])
                
                // User got event from one of his match.
                socketClient.on("message_from_matches_screen", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print ("message_from_matches_screen: \(data)");
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let message = data[0] as! String
                        let nameOfSender = data[3] as! String
                        
                        AJNotificationView.hideCurrentNotificationViewAndClearQueue()
                        
                        AJNotificationView.showNoticeInView(AppDelegate.sharedAppDelegat().window!, type: AJNotificationTypeDwindleApp, title: nameOfSender+": "+message, linedBackground: AJLinedBackgroundTypeDisabled, hideAfter: 2.0, response: { () -> Void in
                            
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
                        let nameOfSender = data[3] as! String
                        
                        AJNotificationView.hideCurrentNotificationViewAndClearQueue()
                        
                        AJNotificationView.showNoticeInView(AppDelegate.sharedAppDelegat().window!, type: AJNotificationTypeDwindleApp, title: nameOfSender+": "+message, linedBackground: AJLinedBackgroundTypeDisabled, hideAfter: 2.0, response: { () -> Void in
                
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let playController = AppDelegate.sharedAppDelegat().playController
                                playController.isComingFromOtherScreen = true
                                self.pushControllerInStack(playController, animated: true)
                            })
                        })
                    })
                })
                
                socketClient.on("game_request", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print ("game_request: \(data)");
                    
                    let message = data[0] as! String
                    
                    self.popup = Popup.init(title: "",
                        subTitle: message,
                        cancelTitle: "No",
                        successTitle: "YES",
                        cancelBlock: { () -> Void in
                            
                            self.hidePlayRequestAlert(self.playRequestTimer)
                            
                            self.dwindleSocket.sendEvent("game_request_response_no", data: [data[1],data[3], data[5], data[4]])
                            
                        }, successBlock: { () -> Void in
                           
                            self.hidePlayRequestAlert(self.playRequestTimer)
                            
                            self.dwindleSocket.sendEvent("game_request_response_yes", data: [data[1],data[2], data[3]])
                            
                    })
                    
                    self.popup!.incomingTransition = PopupIncomingTransitionType.BounceFromCenter
                    self.popup!.outgoingTransition = PopupOutgoingTransitionType.BounceFromCenter
                    self.popup!.showPopup()
                    
                    self.playRequestTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(MenuController.hidePlayRequestAlert(_:)), userInfo: data, repeats: false)
                    
//                    let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
//                    let yesAction = UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
//                        
//                        self.hidePlayRequestAlert(self.playRequestTimer)
//                      
//                        self.dwindleSocket.sendEvent("game_request_response_yes", data: [data[1],data[2], data[3]])
//                    })
//                    alert.addAction(yesAction)
//                    let noAction = UIAlertAction(title: "No", style: .Cancel, handler: { (action) -> Void in
//                       
//                        self.hidePlayRequestAlert(self.playRequestTimer)
//                       
//                        self.dwindleSocket.sendEvent("game_request_response_no", data: [data[1],data[3], data[5], data[4]])
//                    })
//                    alert.addAction(noAction)
//                    self.presentViewController(alert)
                    
                })
                
                // User has made a play request but switched screen.
                socketClient.on("startgame", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print ("MenuController=>startgame: \(data)");
                    
                    self.connectWithNetwork(false)
                    self.dismissViewControllerAnimated(false, completion: nil)
                    
                    let playController = AppDelegate.sharedAppDelegat().playController
                    playController.gameInProgress = true
                    
                    let dataStr: String = data[0] as! String
                    
                    let roomUserInfoDict: AnyObject =  playController.JSONParseDictionary(dataStr)
                    let roomName:String = (roomUserInfoDict["RoomName"] as? String)!
                    
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
                
                socketClient.on("message_push_notification_send", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print("message_push_notification_send: \(data)")
                    
                    let playController = AppDelegate.sharedAppDelegat().playController
                    playController.gameInProgress = false
                    
                    let pageCount = data[4] as! Int
                    playController.pagination_user_count = pageCount
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        if self.navigationController?.topViewController?.nameOfClass != GamePlayController.nameOfClass {
                            
                            self.pushControllerInStack(playController, animated: true)
                            
                            let delay = 0.5 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                playController.show90SecTimer()
                            }
                        }
                        else {
                            playController.show90SecTimer()
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
        dwindleSocket.reconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func connectWithNetwork(connect:Bool) {
        
        if connect {
            
            if self.isMovingToParentViewController() {
                
                var delay = 0.35 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    ProgressHUD.show("Connecting to network...", interaction: false)
                    
                    if AppDelegate.sharedAppDelegat().apsUserInfo == nil {
                       
                        delay = 0.65 * Double(NSEC_PER_SEC)
                        time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
        else {
            let delay = 0.35 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                ProgressHUD.dismiss()
            }
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
   
        let sheetController = UIAlertController(title: "Share via", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        sheetController.addAction(cancelAction)
        
        let messageAction = UIAlertAction(title: "Message", style: UIAlertActionStyle.Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSMSAction()
        }
        sheetController.addAction(messageAction)
        
        let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performEmailAction()
        }
        sheetController.addAction(emailAction)
        
        self.presentViewController(sheetController)
    }
    
    // MARK :- SMS STUFF
    
    func performSMSAction(){
        
        if MFMessageComposeViewController.canSendText() {
            
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = kStr_MessageBody
            messageVC.recipients = [""]
            messageVC.messageComposeDelegate = self;
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
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
    
    func performEmailAction() {
        let emailTitle = "Dwindle Dating"//NSLocalizedString("aboutus_email_subject", comment: "Contact Us")
        let messageBody = kStr_MessageBody
        
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
}