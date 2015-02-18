//
//  DistanceSelectionController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit

class DistanceSelectionController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var pickerViewDistance :  UIPickerView!
    @IBOutlet var btnNext       :   UIButton!
    
    func initContentView(){
        btnNext.layer.cornerRadius = 5.0
//        var t0 : CGAffineTransform  = CGAffineTransformMakeTranslation (0, pickerViewDistance.bounds.size.height*2);
//        var s0 : CGAffineTransform  = CGAffineTransformMakeScale       (1.0, 0.5);
//        var t1 : CGAffineTransform  = CGAffineTransformMakeTranslation (0, -pickerViewDistance.bounds.size.height*2);
//        pickerViewDistance.transform = CGAffineTransformMakeScale   ( 1.0, 1.5);

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initContentView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK : - IBActions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier("showPictureSelector", sender: nil)
        
    }
    
    

    
    
    // MARK : -Pickerview DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    // MARK : -Pickerview Delegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 1) { return 1}
        
        return 80
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (component == 1) { return "miles"}
        
        var title = "  " + String(format: "%02d", row)
        return title
    }
    
//    - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
  
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if (component == 0){
            return 50
        }
        return 75
    }

    
    
    
}