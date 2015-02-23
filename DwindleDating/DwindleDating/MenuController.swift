//
//  MenuController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class MenuController: UIViewController , UIActionSheetDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

        
        performSegueWithIdentifier("showGamePlayController", sender: nil)

        
    }
    
    @IBAction func matchButtonPressed(sender: AnyObject) {
   
        
        performSegueWithIdentifier("showMatchListController", sender: nil)
        
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
   
        var sheet = UIActionSheet(title: "Share via", delegate:self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Message", "Email");
        sheet.showFromRect(sender.frame, inView: self.view, animated: true)
        
//        sheet.showFromToolbar(self.inputToolbar);
        
    }
    
    
    
    
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        switch (buttonIndex) {
        case 0:
//            self.demoData.addPhotoMediaMessage();
            break;
            
        case 1:
//            var weakView = self.collectionView as UICollectionView;
//            self.demoData.addLocationMediaMessageCompletion({ () -> Void in
//                weakView.reloadData();
//            });
            break;
            
        default:
            
            break;
            
        }
        
//        JSQSystemSoundPlayer.jsq_playMessageSentSound();
//        self.finishSendingMessageAnimated(true);
    }
    
}