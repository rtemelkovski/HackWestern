//
//  FECircularView.swift
//  @SIGHT
//
//  Created by Illya Bakurov on 1/17/16.
//  Copyright © 2016 @SIGHT. All rights reserved.
//

import UIKit

@IBDesignable
class HWCircularView: UIView {
    
    var isViewDrawn = false
    
    /** The path which represents the circle */
    var circlePathLayer = CAShapeLayer()
    
    /** The colour which circle shape's line will have. In other words: `strokeColour` */
    @IBInspectable
    var lineColour : UIColor = UIColor.consumed
    
    /** The width which circle shape's line will have */
    @IBInspectable
    var lineWidth : CGFloat = 3.0
    
    /** The angle on which circle view will be rotated. In degrees */
    @IBInspectable
    var angle : Double = M_PI;  //rotate 180°, or 1 π radians
    
    /** Percentage of the circle which will be drawn. 0 - no circle at all; 1 - full circle; 0.5 - arc */
    @IBInspectable
    var shownPart : CGFloat = 0.75 {
        didSet {
            //Assigning percentage of the line which wil be shown
            circlePathLayer.strokeEnd = shownPart
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isViewDrawn {
            //Assigning frame of the circle to be the frame of the view
            circlePathLayer.frame = rect
            //Assigning line width
            circlePathLayer.lineWidth = lineWidth
            //Assigning line color
            circlePathLayer.strokeColor = lineColour.cgColor
            //Clearing the fill color
            circlePathLayer.fillColor = UIColor.clear.cgColor
            //Assigning percentage of the line which wil be shown
            circlePathLayer.strokeEnd = shownPart
            //Adding to the current view's layer
            layer.addSublayer(circlePathLayer)
            //Clearing the background of the view
            backgroundColor = UIColor.clear
            
            //Calculating the proper rect for the circle's frame
            var circleFrame = CGRect(x: 0, y: 0, width: rect.width - lineWidth, height: rect.height - lineWidth)
            circleFrame.origin.x = rect.midX - circleFrame.midX
            circleFrame.origin.y = rect.midY - circleFrame.midY
            //Drawing the path of the circle
            circlePathLayer.path = UIBezierPath(ovalIn: circleFrame).cgPath
            //Rotating circle on the proper angle
            circlePathLayer.transform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
            
            isViewDrawn = true
        }
    }
}
