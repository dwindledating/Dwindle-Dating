//
//  PictureSelectionController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

import UIKit


class PictureSelectionController: UIViewController  {
    
    @IBOutlet var btnPicture1       :   RoundButtonView!
    @IBOutlet var btnPicture2       :   RoundButtonView!
    @IBOutlet var btnPicture3       :   RoundButtonView!
    @IBOutlet var btnPicture4       :   RoundButtonView!
    @IBOutlet var btnPicture5       :   RoundButtonView!
    @IBOutlet var btnNext       :   UIButton!
    
    func initContentView(){
        btnNext.layer.cornerRadius = 5.0
        
        self.btnPicture1.borderWidth = 5.0;
        self.btnPicture2.borderWidth = 5.0;
        self.btnPicture3.borderWidth = 5.0;
        self.btnPicture4.borderWidth = 5.0;
        self.btnPicture5.borderWidth = 5.0;
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
        
        performSegueWithIdentifier("showMenuController", sender: nil)
        
    }

    @IBAction func openImagePicker(sender: UIButton) {
        
//        performSegueWithIdentifier("showMenuController", sender: nil)
        
    }

    
    
}