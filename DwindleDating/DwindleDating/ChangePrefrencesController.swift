//
//  ChangePrefrencesController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 4/25/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import Foundation


class ChangePrefrencesController: BaseController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    //MARK: - TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    
    //MARK: - TableView Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell_ : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("identifier") 
        if(cell_ == nil)
        {
            cell_ = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "identifier")
            
            cell_?.accessoryType = UITableViewCellAccessoryType.None
            let checkImage = UIImage(named: "accessory")
            let checkmark = UIImageView(image: checkImage)
            cell_?.accessoryView = checkmark
            cell_?.backgroundColor = UIColor.clearColor()
        }
        
        
        var text: String!
        
        if (indexPath.row == 0){
            text = "Change Gender"
        }
        else if(indexPath.row == 1){
            text = "Change Age"
        }
        else if(indexPath.row == 2){
            text = "Change Distance"
        }
        
        cell_!.textLabel!.text = text
        
        return cell_!
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row == 0){
            self.performSegueWithIdentifier("showEditGenderController", sender: nil)
        }
        else if (indexPath.row == 1){
            self.performSegueWithIdentifier("showEditAgeController", sender: nil)
        }
        else if (indexPath.row == 2){
            self.performSegueWithIdentifier("showEditDistanceController", sender: nil)
        }
        
        
    }
    
    
}