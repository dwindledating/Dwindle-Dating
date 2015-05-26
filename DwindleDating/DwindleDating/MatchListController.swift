//
//  MatchesController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/27/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class MatchListController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet var tableview: UITableView!
    
    var matchesArr : NSArray!
    
    
    // MARK:- WEB SERVICE
    
    
    func getMatches (){
        
        
        ProgressHUD.show("Loading Matches")
        var settings = UserSettings.loadUserSettings()
        var manager = ServiceManager()
        
        manager.getMathchesForUser(settings.fbId, sucessBlock: { (_matchesArr:[AnyObject]!) -> Void in
            //code
            self.matchesArr = NSArray(array: _matchesArr)
            self.tableview.reloadData()
            ProgressHUD.dismiss()
            
            }) { (error: NSError!) -> Void in
            //code
            ProgressHUD.showError("\(error.localizedDescription)")
        }
    }
    
    
    // MARK:-
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        var msg1 = "Pls tell me the card this year doesnot include us in ugly sweaters or anything that..."
//        var msg2 = "This bad boy hit the front page last night. Chocked for a bit but never went down, thank... "
//        var msg3 = "We are all jammed up but we can focus on getting this done and public in 3 days..."
//        var msg4 = "All done. Moving onto the maps for the 6. Take a look and let me know what you think. Thanks!"
//        var msg5 = "We got a lunch train going to Brazen Head. You in?"
//        
//        var dict1 :NSDictionary = ["name":"Jon Lax", "message":msg1, "time":"10:10 AM", "pictureUrl":""]
//        var dict2 :NSDictionary = ["name":"Christi", "message":msg2, "time":"09:41 AM", "pictureUrl":""]
//        var dict3 :NSDictionary = ["name":"Geoff Teehan", "message":msg3, "time":"Yesterday", "pictureUrl":""]
//        var dict4 :NSDictionary = ["name":"Nelson Leung", "message":msg4, "time":"Yesterday", "pictureUrl":""]
//        var dict5 :NSDictionary = ["name":"Matt Hodgins", "message":msg5, "time":"Monday", "pictureUrl":""]
//        
//        namesArr = [dict1,dict2,dict3,dict4,dict5]
        self.getMatches()
        tableview.tintColor = UIColor.purpleColor()
        //        tableview.backgroundColor = UIColor.purpleColor()
        //        UITableView.appearance().tintColor = UIColor.purpleColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if let matches = matchesArr {
            return matches.count
        }
 
        return 0;
    }
    
    
    //MARK: - TableView Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell_ : MatchCell? = tableView.dequeueReusableCellWithIdentifier("matchIdentifier") as? MatchCell
        var match = matchesArr[indexPath.row] as! Match
        
        if(cell_ != nil)
        {
            cell_?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell_?.imgViewProfile.borderWidth = 0;
            cell_?.lblName.text     = match.fbId
            cell_?.lblDetail.text   = match.text//matchDict["message"] as? String
            cell_?.lblTime.text     = match.date//["time"] as? String
            cell_?.imgViewProfile.sd_setImageWithURL(match.imgPath)
        }
        
        
        
        
        return cell_!
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
            self.performSegueWithIdentifier("showMatchChatController", sender: self)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showMatchChatController") {
            self.navigationController?.setNavigationBarHidden(false, animated: false)

//            var signupVC = (segue.destinationViewController as SignupController)
//            
//            //Set Profile Image
//            let urlPath: String = "http://graph.facebook.com/"  + UserSettings.loadUserSettings().fbId + "/picture?type=large"
//            var url: NSURL = NSURL(string: urlPath)!
//            signupVC.userImgUrl = url
//            
//            //Set Welcome Message
//            signupVC.userName = UserSettings.loadUserSettings().fbName
            
            
        }
    }
    
    
    
    
}