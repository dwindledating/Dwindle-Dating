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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        return 4;
    }
    
    
    //MARK: - TableView Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell_ : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("identifier") as? UITableViewCell
        if(cell_ == nil)
        {
            cell_ = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "identifier")
            
            cell_?.accessoryType = UITableViewCellAccessoryType.None
            let checkImage = UIImage(named: "accessory")
            let checkmark = UIImageView(image: checkImage)
            cell_?.accessoryView = checkmark
            
        }
        
        
        var text: String!
        
        if (indexPath.row == 0){
            text = "Edit Picture"
        }
        else if(indexPath.row == 1){
            text = "Change Preferences"
        }
        else if(indexPath.row == 2){
            text = "Terms and Condition"
        }
        else if(indexPath.row == 3){
            text = "Privacy Policy"
        }
        
        
        
        cell_!.textLabel!.text = text
        
        return cell_!
        
    }
    
    
    func alert(title: String, message: String) {
        if let getModernAlert: AnyClass = NSClassFromString("UIAlertController") { // iOS 8
            let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        } else { // iOS 7
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            
            alert.title = title
            alert.message = message
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
    }
    
    @IBAction func logout(sender: UIButton) {
        
        self.alert("Logout", message: "Are you sure you want to logout")
        
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.userInteractionEnabled = true
        view.backgroundColor = UIColor.grayColor()
        view.frame = CGRectMake(0,0,tableview.frame.size.width , 80)
        let button = UIButton()
        button.frame = CGRectMake(30,20,tableview.frame.size.width - 40, 40)
        button.backgroundColor = UIColor(red: 1.0 , green:0, blue: 75.0/255.0, alpha: 1.0)
        button.setTitle("Logout", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5;
        button.enabled = true
        button.addTarget(self, action: Selector("logout:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        return view
    }
    
    
    
}