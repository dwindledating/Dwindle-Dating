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
        
        let sourceViewController = self.sourceViewController
        let navC = sourceViewController.navigationController!
        let noOfViewControllers = navC.viewControllers.count
        
        if (noOfViewControllers < 3){
            return nil
        }
        else{
            return navC.viewControllers[noOfViewControllers - 3]
        }
    }
    
    override func perform() {
        //
        let sourceViewController = self.sourceViewController
        let navC = sourceViewController.navigationController!
        navC.popToViewController(self.backViewController()!, animated: true)
    }
}