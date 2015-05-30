//
//  ColorView.swift
//  No. 2 Stylus
//
//  Created by Waheeda on 20/05/2015.
//  Copyright (c) 2015 nibbee. All rights reserved.
//

import Foundation

class ColorView:UIView {
    

     var onTapTarget: UIViewController?
    var selector: Selector = ""
    
    override func awakeFromNib() {
        var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector( "onTap") )
        self.addGestureRecognizer(tapGestureRecognizer)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setBackgroundColorOfView(color: UIColor) {
    
        self.backgroundColor = color;
    }
    func setViewTag(tag: Int) {
       self.tag = tag
    }
    
    func onTap() {
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeScale(1.01, 1.01)
            self.alpha = 0.8
            }, completion: { finished in
                UIView.animateWithDuration(0.1, delay: 0.1, options: nil, animations: {
                       self.transform = CGAffineTransformMakeScale(1, 1)
                    self.alpha = 1
                    }, completion: { finished in
                        self.notifyTarget()
                })
        })
        
        
    
    }
    
    func notifyTarget() {
    //onTapTarget?.pencilPressed(self)
        onTapTarget?.swift_performSelector(selector, withObject: self)
    }
 
    
    
}