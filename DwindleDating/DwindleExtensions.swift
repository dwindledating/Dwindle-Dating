//
//  DwindleExtensions.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 15/11/2015.
//  Copyright © 2015 infinione. All rights reserved.
//

import Foundation

public extension Array {
    
    func shuffled() -> [Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex { // Check if you are not trying to swap an element with itself
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
}

// MARK: - NSStringFromClass
public extension NSObject {
    
    public class var nameOfClass: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    public var nameOfClass: String{
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}

public extension UIViewController {
    
    func isViewControllerinNavigationStack(controller:UIViewController)-> Bool {
        
        var exist = false
        
        if let nav = controller.navigationController where nav.viewControllers.contains(controller) == true {
            exist = true
        }
        return exist
    }
    
    func pushControllerInStack(controller:UIViewController, animated:Bool) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if self.isViewControllerinNavigationStack(controller) {
                self.navigationController?.popToViewController(controller, animated: false)
            }
            else {
                self.navigationController?.pushViewController(controller, animated: animated)
            }
        }
    }
    
    var viewIsLoaded:Bool {
        
        var isLoaded = false
        if let nav = self.navigationController where nav.topViewController == self {
            isLoaded = true
        }
        
        return isLoaded //(self.isViewLoaded() == true && self.view.window != nil)
    }
    
    func presentViewController(controler:UIViewController) {
       
        if self.viewIsLoaded {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(controler, animated: true, completion: nil)
            }
        }
    }
}
