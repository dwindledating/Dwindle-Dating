//
//  BaseViewController.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 23/12/2015.
//  Copyright © 2015 infinione. All rights reserved.
//

import UIKit

class BaseViewController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let dwindleSocket = DwindleSocketClient.sharedInstance
        
        if dwindleSocket.status() == .Connected {
            let settings = UserSettings.loadUserSettings()
            dwindleSocket.sendEvent("event_change_user_status", data: [settings.fbId, "loggedin"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
