//
//  ColorView.swift
//  No. 2 Stylus
//
//  Created by Waheeda on 20/05/2015.
//  Copyright (c) 2015 nibbee. All rights reserved.
//

import Foundation

class ColorView:UIView {
    

     var onTapTarget: DrawingViewController?
    
    override func awakeFromNib() {
        var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector( "onTap") )
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setBackgroundColorOfView(color: UIColor) {
    
        self.backgroundColor = color;
    }
    func setViewTag(tag: Int) {
       self.tag = tag
    }
    
    func onTap() {
        
        UIView.animateWithDuration(0.05, delay: 0.0, options: .CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeScale(1.01, 1.01)
            self.alpha = 0.8
            }, completion: { finished in
                UIView.animateWithDuration(0.05, delay: 0.1, options: nil, animations: {
                       self.transform = CGAffineTransformMakeScale(1, 1)
                    self.alpha = 1
                    }, completion: { finished in
                        self.notifyTarget()
                })
        })
        
        
    
    }
    
    func notifyTarget() {
    onTapTarget?.pencilPressed(self)
    }
 
    
}