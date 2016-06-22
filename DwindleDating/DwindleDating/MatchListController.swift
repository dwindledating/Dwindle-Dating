//
//  MatchesController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/27/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class MatchListController: BaseViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet var tableview: UITableView!
    
    var matchesArr : NSMutableArray!
    
    // MARK:- WEB SERVICE
    
    func backViewController() -> UIViewController? {
        let navC = self.navigationController!
        let noOfViewControllers = navC.viewControllers.count
        if (noOfViewControllers < 2){
            return nil
        }
        else{
            return navC.viewControllers[noOfViewControllers - 2]
        }
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {

        let viewController = self.backViewController()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if viewController!.isKindOfClass(GamePlayController)
        {
            self.performSegueWithIdentifier("popToMenu", sender: nil)
            return false
        }
        
        return true
    }
    
    func getMatches (){
        
        
        ProgressHUD.show("Loading Matches")
        let settings = UserSettings.loadUserSettings()
        let manager = ServiceManager()
        
        manager.getMathchesForUser(settings.fbId, sucessBlock: { (_matchesArr:[AnyObject]!) -> Void in
            //code
            
            
            if let matches = self.matchesArr{
                matches.removeAllObjects()
            }
            self.matchesArr = NSMutableArray(array: _matchesArr)
            self.tableview.reloadData()
            ProgressHUD.dismiss()
            
            }) { (error: NSError!) -> Void in
            //code
                if (error.code == 420){
                    ProgressHUD.show("You don't have any matches yet :(", withSpin: false)

                }else{
                    ProgressHUD.showError("\(error.localizedDescription)")
                }
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
        ProgressHUD.dismiss()
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
        
        var cell_ =  tableView.dequeueReusableCellWithIdentifier("matchIdentifier", forIndexPath: indexPath) as? MatchCell
        
        let match = matchesArr[indexPath.row] as! Match
        
        if(cell_ == nil) {
            cell_ = MatchCell(style: UITableViewCellStyle.Default, reuseIdentifier: "matchIdentifier")
        }
        
        cell_?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell_?.imgViewProfile.borderWidth = 0;
        cell_?.lblName.text     = match.name
        cell_?.lblDetail.text   = match.text//matchDict["message"] as? String
        cell_?.lblTime.text     = match.date//["time"] as? String
        cell_?.imgViewProfile.sd_setImageWithURL(match.imgPath)
        if (!match.statusMessage){
            var font = cell_?.lblDetail.font
            font = UIFont.boldSystemFontOfSize(font!.pointSize)
            cell_?.lblDetail.font = font
            cell_?.backgroundColor = UIColor(red: 228/255.0, green: 240.0/255.0, blue: 250/255.0, alpha: 1.0)
        }
        else{
            var font = cell_?.lblDetail.font
            font = UIFont.systemFontOfSize(font!.pointSize)
            cell_?.lblDetail.font = font
            cell_?.backgroundColor = UIColor.clearColor()
        }
        
        return cell_!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let match = matchesArr[indexPath.row] as! Match
        
        let matchControler = AppDelegate.sharedAppDelegat().matchChatController
        matchControler.isComingFromPlayScreen = false
        matchControler.toUserId = match.fbId
        matchControler.toUserName = match.name
        matchControler.status = match.status
        self.navigationController?.pushViewController(matchControler, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showMatchChatController") {
            self.navigationController?.setNavigationBarHidden(false, animated: false)

            let indexPath: NSIndexPath = sender as! NSIndexPath;
            
            let match = matchesArr[indexPath.row] as! Match

            let matchControl = (segue.destinationViewController as! MatchChatController)
            
            matchControl.toUserId = match.fbId
            matchControl.toUserName = match.name
            matchControl.status = match.status
        }
        else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}