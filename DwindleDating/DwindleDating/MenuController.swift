//
//  MenuController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class MenuController: UIViewController  {
    
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
   
        
        
    }
    
}