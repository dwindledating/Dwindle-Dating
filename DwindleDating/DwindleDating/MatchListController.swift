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
    
    var matchesArr : NSMutableArray!
    
    
    // MARK:- WEB SERVICE
    
    
    func getMatches (){
        
        
        ProgressHUD.show("Loading Matches")
        var settings = UserSettings.loadUserSettings()
        var manager = ServiceManager()
        
        manager.getMathchesForUser(settings.fbId, sucessBlock: { (_matchesArr:[AnyObject]!) -> Void in
            //code
            
            
            if let matches = self.matchesArr{
                self.matchesArr.removeAllObjects()
            }
            self.matchesArr = NSMutableArray(array: _matchesArr)
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
    
    override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            self.getMatches()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableview.tintColor = UIColor.purpleColor()
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
        
            self.performSegueWithIdentifier("showMatchChatController", sender: indexPath)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showMatchChatController") {
            self.navigationController?.setNavigationBarHidden(false, animated: false)

            var indexPath: NSIndexPath = sender as! NSIndexPath;
            
            var match = matchesArr[indexPath.row] as! Match

            var matchControl = (segue.destinationViewController as! MatchChatController)
            
            
            matchControl.toUserId = match.fbId
            matchControl.status = match.status

            
            
        }
    }
    
    
    
    
}