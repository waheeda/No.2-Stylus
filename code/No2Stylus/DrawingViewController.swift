//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, ACEDrawingViewDelegate {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var drawingParentView: UIView!
    @IBOutlet weak var autoLayoutConstraintForScrollViewBottom: NSLayoutConstraint!
    @IBOutlet  var navUndoButton: UIBarButtonItem!
    @IBOutlet  var navBackButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var eraserButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
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
    var paperType:PaperType = PaperType.Sketch;
    
  
  let colors: [(CGFloat, CGFloat, CGFloat)] = [
    
    
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (0, 0, 0),
    (1.0, 1.0, 1.0),
  ]

    @IBAction func onEraserButtonClick(sender: AnyObject) {
        
        self.drawingView.drawTool = ACEDrawingToolTypeEraser;
    }
    @IBAction func onColorsButtonClick(sender: AnyObject) {
        
       showColorSelector()
        
    }
    
    func showColorSelector() {
        self.autoLayoutConstraintForScrollViewBottom.constant = 0
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            }, completion: { finished in
                
        })
    }
    
    func hideColorSelector() {
        self.autoLayoutConstraintForScrollViewBottom.constant = -scrollView.frame.size.height
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            }, completion: { finished in
                
        })
    }
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    settingsButton.alpha = 0.2;
     mainImageView.image = UIImage(named: imageName);
    self.drawingView.delegate = self;
    eraserButton.layer.cornerRadius = 25;
//    logoImage.alpha = 0.5;
    logoImage.hidden = true;
    
  }
    
    override func viewDidAppear(animated: Bool) {
         autoLayoutConstraintForScrollViewBottom.constant = -scrollView.frame.size.height;
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setColorsInScrollView()
    }
    
    func setColorsInScrollView() {
    
        var index = 0
        
        for view in self.scrollView.subviews{
            var r:CGFloat = 0.0;
            var g:CGFloat = 0.0;
            var b: CGFloat = 0.0;
            (r,g,b) = colors[index]
            var color:UIColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
            if let subview = view as? ColorView {
                subview.setViewTag(index)
                subview.setBackgroundColorOfView(color)
                subview.onTapTarget = self
                subview.selector = Selector("pencilPressed:");
                index++
            }
            
            
        }
    }
    
  override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    self.customizeBasedOnSelectedPaperType()
    UINavigationBar.appearance().barTintColor = UIColor.blackColor();
    self.navigationController?.navigationBarHidden = false;
    self.navigationItem.hidesBackButton = true
    self.title = self.navigationTitle;
    
    updateButtonsStatus()
     }
    
    func customizeBasedOnSelectedPaperType() {
    
        var imageName:String = ""
        var selectedPaperType: String = ""
        
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
        
        
        self.navigationTitle = selectedPaperType;
        self.imageName = imageName;
         mainImageView.image = UIImage(named: imageName);
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
    
    func  drawingView(view: ACEDrawingView!, willBeginDrawUsingTool tool: ACEDrawingTool!) {
       hideColorSelector()
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
    
    logoImage.hidden = false;
    UIGraphicsBeginImageContext(drawingParentView.bounds.size)
    drawingParentView.layer.renderInContext(UIGraphicsGetCurrentContext())
//    drawingParentView?.drawInRect(CGRect(x: 0, y: 0,
//      width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    logoImage.hidden = true;
     
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    presentViewController(activity, animated: true, completion: nil)
  }
  
  @IBAction func pencilPressed(sender: AnyObject) {
    
    self.drawingView.drawTool = ACEDrawingToolTypePen;
    hideColorSelector()
    
    isEraserSelected = false
    
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count {
      index = 0
    }
    
    (red, green, blue) = colors[index]
    
    
    self.drawingView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacity);

  }
  
//  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//    swiped = false
//    if let touch = touches.anyObject() as? UITouch {
//      lastPoint = touch.locationInView(self.view)
//    }
//  }
  
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
    
    if self.red != settingsViewController.red || self.green != settingsViewController.green || self.blue != settingsViewController.blue {
        
        self.drawingView.drawTool = ACEDrawingToolTypePen;
    }
    
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
    
    
    
    self.paperType = settingsViewController.paperType;
    self.drawingView.lineAlpha = self.opacity
    self.drawingView.lineWidth = self.brushWidth
     self.drawingView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacity);
    
    
  }
}

