//
//  GraphViewCircle.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import UIKit

extension UIButton {
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var relativeFrame = self.bounds
        var hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        var hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return CGRectContainsPoint(hitFrame, point)
    }
}

@IBDesignable class GraphViewCircle: UIButton {

    var isFilled:Bool = false
    var emptyColor:UIColor = UIColor.whiteColor()
    var filledColor:UIColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        self.drawCircles(rect.origin, size: rect.size)
    }
    
    func drawCircles(position: CGPoint, size:CGSize) {
        //let size:CGSize = CGSize(width: 12, height: 12)
        let newPosition:CGPoint = CGPoint(x: position.x, y: position.y)
        
        var rect:CGRect = CGRect(origin: position, size: size)
        rect = CGRectInset(rect, 2, 2)
        
        var ovalPath = UIBezierPath(ovalInRect: rect)
        ovalPath.lineWidth = 3
        emptyColor.setFill()
        filledColor.setStroke()
        ovalPath.stroke()
        ovalPath.fill()
        
        let rectSmall:CGRect = CGRectInset(rect, 2, 2)
        
        var ovalPath2 = UIBezierPath(ovalInRect: rectSmall)
        ovalPath2.lineWidth = 1

        emptyColor.setFill()
        if isFilled {
            filledColor.setFill()
        }
        ovalPath2.fill()
        
    }

}
