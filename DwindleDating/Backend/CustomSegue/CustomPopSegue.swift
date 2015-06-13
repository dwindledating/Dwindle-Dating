//
//  CustomPopSegue.swift
//  DwindleDating
//
//  Created by macbookpro on 12/06/2015.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

@objc(CustomPopSegue)

class CustomPopSegue: UIStoryboardSegue {

    
    func backViewController() -> UIViewController?{
        let sourceViewController : UIViewController = (self.sourceViewController as? UIViewController)!
        let navC = sourceViewController.navigationController!
        let noOfViewControllers = navC.viewControllers.count
        if (noOfViewControllers < 3){
            return nil
        }
        else{
            return navC.viewControllers[noOfViewControllers - 3] as? UIViewController
        }
    }
    
    override func perform() {
        //
        let sourceViewController : UIViewController = (self.sourceViewController as? UIViewController)!
        let navC = sourceViewController.navigationController!
        navC.popToViewController(self.backViewController()!, animated: true)
        
    }
}