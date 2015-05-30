import UIKit

protocol SettingsViewControllerDelegate: class {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {

//    @IBOutlet weak var scrollVewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var sliderBrush: UISlider!
  @IBOutlet weak var sliderOpacity: UISlider!

  @IBOutlet weak var imageViewBrush: UIImageView!
  @IBOutlet weak var imageViewOpacity: UIImageView!

  @IBOutlet weak var labelBrush: UILabel!
    
  @IBOutlet weak var labelOpacity: UILabel!

  @IBOutlet weak var sliderRed: UISlider!
  @IBOutlet weak var sliderGreen: UISlider!
  @IBOutlet weak var sliderBlue: UISlider!

  @IBOutlet weak var labelRed: UILabel!
  @IBOutlet weak var labelGreen: UILabel!
  @IBOutlet weak var labelBlue: UILabel!
  
  var brush: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  
    
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
    
  weak var delegate: SettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
// self.setColorsInScrollView()
    // Do any additional setup after loading the view.
    sliderOpacity.setThumbImage(sliderOpacity.thumbImageForState(.Normal), forState:.Normal)
    sliderBrush.setThumbImage(sliderBrush.thumbImageForState(.Normal), forState:.Normal)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func close(sender: AnyObject) {
     self.delegate?.settingsViewControllerFinished(self)
    dismissViewControllerAnimated(true, completion: nil)
   
  }

    @IBAction func reset(sender:AnyObject) {
    
        self.brush = 10;
        self.opacity = 1;
        self.red = 0;
        self.green = 0;
        self.blue = 0;
        self.setupUI()
    }
  @IBAction func colorChanged(sender: UISlider) {
    red = CGFloat(sliderRed.value / 255.0)
    labelRed.text = NSString(format: "%d", Int(sliderRed.value))
    green = CGFloat(sliderGreen.value / 255.0)
    labelGreen.text = NSString(format: "%d", Int(sliderGreen.value))
    blue = CGFloat(sliderBlue.value / 255.0)
    labelBlue.text = NSString(format: "%d", Int(sliderBlue.value))
     
    drawPreview()
  }

  @IBAction func sliderChanged(sender: UISlider) {
    if sender == sliderBrush {
      brush = CGFloat(sender.value)
//      labelBrush.text = NSString(format: "%.2f", brush.native)
    } else {
      opacity = CGFloat(sender.value)
      labelOpacity.text = self.getTextForOpacityLabel()
    }
     
    drawPreview()
  }
    
    func getTextForOpacityLabel() -> NSString {
        return NSString(format: "%d%%", (Int)(opacity.native*100))
    }
  
  func drawPreview() {
    UIGraphicsBeginImageContext(imageViewBrush.frame.size)
    var context = UIGraphicsGetCurrentContext()
   
    CGContextSetLineCap(context, kCGLineCapRound)
    CGContextSetLineWidth(context, brush)
   
//    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
     CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
    CGContextMoveToPoint(context, 45.0, 45.0)
    CGContextAddLineToPoint(context, 45.0, 45.0)
    CGContextStrokePath(context)
    imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
   
    UIGraphicsBeginImageContext(imageViewBrush.frame.size)
    context = UIGraphicsGetCurrentContext()
   
    CGContextSetLineCap(context, kCGLineCapRound)
    CGContextSetLineWidth(context, 20)
    CGContextMoveToPoint(context, 45.0, 45.0)
    CGContextAddLineToPoint(context, 45.0, 45.0)
   
//    CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
//    CGContextStrokePath(context)
//    imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
   
    UIGraphicsEndImageContext()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 180/255, blue: 223/255, alpha: 1.0);
    self.navigationController?.navigationBarHidden = false;
  
    
    self.setupUI()
    
//    labelBrush.text = NSString(format: "%.1f", brush.native)
    
//    sliderRed.value = Float(red * 255.0)
//    labelRed.text = NSString(format: "%d", Int(sliderRed.value))
//    sliderGreen.value = Float(green * 255.0)
//    labelGreen.text = NSString(format: "%d", Int(sliderGreen.value))
//    sliderBlue.value = Float(blue * 255.0)
//    labelBlue.text = NSString(format: "%d", Int(sliderBlue.value))
   
    
  }

    func setupUI() {
    
        sliderBrush.value = Float(brush)
        sliderOpacity.value = Float(opacity)
        labelOpacity.text = self.getTextForOpacityLabel()
        drawPreview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setColorsInScrollView()
    }
    
    func setColorsInScrollView() {
        
//        scrollView.contentOffset = CGPointZero
//        var containerFrame:CGRect = scrollVewContainer.frame
//        var scrollViewFrame = scrollView.frame
//        
//        scrollViewFrame.size.height = containerFrame.size.height
//        
//        scrollView.frame = scrollViewFrame
////
//        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollViewFrame.size.height)
        
        var index = 0
        
        for view in self.scrollView.subviews{
            var r:CGFloat = 0.0;
            var g:CGFloat = 0.0;
            var b: CGFloat = 0.0;
            (r,g,b) = colors[index]
            var color:UIColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
            if let subview = view as? ColorView {
                print(scrollView.superview?.frame)
                print (scrollView.frame)
                print (subview.frame)
                subview.setViewTag(index)
                subview.setBackgroundColorOfView(color)
                subview.onTapTarget = self
                subview.selector = Selector("pencilPressed:");
//                var frame:CGRect = subview.frame;
//                frame.size.height = scrollViewFrame.size.height;
//                subview.frame = frame;
                index++
                
                
            }
            
            
        }
    }
    @IBAction func pencilPressed(sender: AnyObject) {
        
//        hideColorSelector()
//        
//        isEraserSelected = false
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        drawPreview()
//      var color = UIColor(red: red, green: green, blue: blue, alpha: opacity);
//        print(color)
        
//        self.drawingView.drawTool = ACEDrawingToolTypePen;
//        self.drawingView.lineColor = UIColor(red: red, green: green, blue: blue, alpha: opacity);
        
    }
    
    var paperType:PaperType = PaperType.Sketch;
    @IBAction func onButtonClick (sender: AnyObject) {
        
        var tag = sender.tag;
        
        paperType = PaperType(rawValue: tag!)!;
        self.close(sender)
        
        
//        self.performSegueWithIdentifier(self.segueIdentifier, sender: sender);
        
    }
    
}
