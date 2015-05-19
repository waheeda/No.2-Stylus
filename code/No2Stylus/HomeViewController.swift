//
//  HomeViewController.swift
//  No. 2 Stylus
//
//  Created by Waheeda on 19/04/2015.
//  Copyright (c) 2015 nibbee. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    enum PaperType: Int {
         case Sketch = 1, Write, Grid;
    }
    
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
        var imageName:String = ""
        
        switch paperType {
            
        case .Sketch:
            selectedPaperType = "Sketch"
            imageName = ""
        case .Write:
            selectedPaperType = "Write"
            imageName = "noteBookBg"
        case .Grid:
            selectedPaperType = "Grid"
            imageName = "grid"
            
        }
        
        
        drawingController.navigationTitle = selectedPaperType;
        drawingController.imageName = imageName;
       
        
    }
    }
    
}
