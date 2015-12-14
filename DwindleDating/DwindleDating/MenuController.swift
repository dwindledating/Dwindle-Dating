//
//  MenuController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit
import MessageUI


class MenuController: UIViewController ,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dwindleSocket = DwindleSocketClient.sharedInstance
        dwindleSocket.EventHandler(true) { (socketClient: SocketIOClient) -> Void in
            
            if socketClient.status == .Connected { // We are save to proceed
                print("MenuController. Socket connected")
                
                // User got event from one of his match.
                socketClient.on("message_from_matches_screen", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print ("message_from_matches_screen: \(data)");
                })
                
                // User got play event from other user. This could be a push message as well.
                socketClient.on("message_from_play_screen", callback: { (data:[AnyObject], ac:SocketAckEmitter) -> Void in
                    print ("message_from_play_screen: \(data)");
                })
                
                // User has made a play request but switched screen.
                socketClient.on("message_game_started", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print ("message_game_started: \(data)");
                })
                
                socketClient.on("APNS Response", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print ("APNS Response: \(data)");
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK : - IBActions
    
    @IBAction func settingButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showSettingsController", sender: nil)
    }

    
    @IBAction func playButtonPressed(sender: AnyObject) {

//        performSegueWithIdentifier("showGamePlayController", sender: nil)

        self.navigationController?.pushViewController(AppDelegate().playController, animated: true)
        
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