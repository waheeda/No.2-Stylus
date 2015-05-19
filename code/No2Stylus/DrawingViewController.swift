//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, ACEDrawingViewDelegate {

    @IBOutlet  var navUndoButton: UIBarButtonItem!
    @IBOutlet  var navBackButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!

    @IBOutlet weak var drawingView: ACEDrawingView!
  var lastPoint = CGPoint.zeroPoint
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false
  var isEraserSelected = false;
    
     var navigationTitle:String = "Draw";
    var imageName:String = "";
    
  
  let colors: [(CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (1.0, 1.0, 1.0),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    settingsButton.alpha = 0.2;
     mainImageView.image = UIImage(named: imageName);
    self.drawingView.delegate = self;
    
  }
    
  override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    
    UINavigationBar.appearance().barTintColor = UIColor.blackColor();
    self.navigationController?.navigationBarHidden = false;
    self.navigationItem.hidesBackButton = true
    self.title = self.navigationTitle;
    
    updateButtonsStatus()
     }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    
    func drawingView(view: ACEDrawingView!, didEndDrawUsingTool tool: ACEDrawingTool!) {
        self.updateButtonsStatus()
    }
    func updateButtonsStatus() {
        var canUndo: Bool = self.drawingView.canUndo()
        if(canUndo == true) {
        self.navigationItem.leftBarButtonItem = self.navUndoButton
        }else {
        self.navigationItem.leftBarButtonItem = self.navBackButton
        }
    }
    
    // MARK: - Actions

    @IBAction func onBackButtonClick(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func undo(sender: AnyObject) {
        
        self.drawingView.undoLatestStep();
        
        self.updateButtonsStatus()
    }
  @IBAction func reset(sender: AnyObject) {
    mainImageView.image = nil
  }

  @IBAction func share(sender: AnyObject) {
    UIGraphicsBeginImageContext(mainImageView.bounds.size)
    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, 
      width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
     
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    presentViewController(activity, animated: true, completion: nil)
  }
  
  @IBAction func pencilPressed(sender: AnyObject) {
    
    isEraserSelected = false
    
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count {
      index = 0
    }
    
    (red, green, blue) = colors[index]
    
    self.drawingView.drawTool = ACEDrawingToolTypePen;
    self.drawingView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacity);
    
    if index == colors.count - 1 {
//      opacity = 1.0
//        isEraserSelected = true
         self.drawingView.drawTool = ACEDrawingToolTypeEraser;
    }
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    swiped = false
    if let touch = touches.anyObject() as? UITouch {
      lastPoint = touch.locationInView(self.view)
    }
  }
  
//  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
//    
//    // 1
//    UIGraphicsBeginImageContext(view.frame.size)
//    let context = UIGraphicsGetCurrentContext()
//    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//    
//    // 2
//    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
//    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
//    
//    // 3
//    CGContextSetLineCap(context, kCGLineCapRound)
//    CGContextSetLineWidth(context, brushWidth)
//    if(isEraserSelected) {
//        var color  = UIColor(patternImage: UIImage(named: "noteBookBg.png")!)
//        var colorComponents = CGColorGetComponents(color.CGColor!)
//        var red:CGFloat = colorComponents[0]
//        var green: CGFloat = colorComponents[1]
//        CGContextSetRGBStrokeColor(context, colorComponents[0], colorComponents[1], colorComponents[2],colorComponents[3]);
//        CGContextSetBlendMode(context, kCGBlendModeClear)
//    }
//    else {
//        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
//    CGContextSetBlendMode(context, kCGBlendModeNormal)
//    }
//    
//    // 4
//    CGContextStrokePath(context)
//    
//    // 5
//    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//    tempImageView.alpha = opacity
//    UIGraphicsEndImageContext()
//    
//  }
//
//  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//    // 6
//    swiped = true
//    if let touch = touches.anyObject() as? UITouch {
//      let currentPoint = touch.locationInView(view)
//      drawLineFrom(lastPoint, toPoint: currentPoint)
//      
//      // 7
//      lastPoint = currentPoint
//    }
//  }
//  
//  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//
//    if !swiped {
//      // draw a single point
//      drawLineFrom(lastPoint, toPoint: lastPoint)
//    }
//    
//    // Merge tempImageView into mainImageView
//    UIGraphicsBeginImageContext(mainImageView.frame.size)
//    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
//    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
//    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    tempImageView.image = nil
//  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let navigationController = segue.destinationViewController as UINavigationController
    let settingsViewController = navigationController.topViewController as SettingsViewController
    settingsViewController.delegate = self
    settingsViewController.brush = brushWidth
    settingsViewController.opacity = opacity
    settingsViewController.red = red
    settingsViewController.green = green
    settingsViewController.blue = blue
  }
  
}

extension DrawingViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
    
    
    self.drawingView.lineAlpha = self.opacity
    self.drawingView.lineWidth = self.brushWidth
     self.drawingView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacity);
    
    
  }
}

