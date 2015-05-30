//
//  HomeViewController.swift
//  No. 2 Stylus
//
//  Created by Waheeda on 19/04/2015.
//  Copyright (c) 2015 nibbee. All rights reserved.
//

import UIKit

enum PaperType: Int {
    case Sketch = 1, Write, Grid;
}

class HomeViewController: UIViewController {

     var selectedPaperType:String = "" ;
    var paperType:PaperType = PaperType.Sketch;
    
    let segueIdentifier = "openDrawingController";
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBarHidden = true;
    }
    
    @IBAction func onButtonClick (sender: AnyObject) {
    
        var tag = sender.tag;
        
        paperType = PaperType(rawValue: tag!)!;
        
        
        
        self.performSegueWithIdentifier(self.segueIdentifier, sender: sender);
        
    }
    
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == self.segueIdentifier) {
    
        var drawingController:DrawingViewController = segue.destinationViewController as DrawingViewController;
        drawingController.paperType = paperType;
       
        
    }
    }
    
}
