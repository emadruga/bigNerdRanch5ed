//
//  DrawView.swift
//  TouchTracker
//
//  Created by Ewerton Madruga on 5/23/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentCircles  = [NSValue:Circle]()
    var finishedCircles = [Circle]()
    
    @IBInspectable var finishedCircleColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentCircleColor: UIColor = UIColor.cyanColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - drawRect support functions
    
    func getRectFromCircle(circle: Circle) -> CGRect {
        let size = CGSize(width: circle.diameter, height: circle.diameter)
        let rect = CGRect(origin: circle.loc, size: size)
        
        return rect
    }
    
    func getNewDiameter(origin: CGPoint, newLocation: CGPoint) -> CGFloat {
        var response : CGFloat = 0
        
        response = min(abs(origin.x - newLocation.x), abs(origin.y - newLocation.y))
        
        return response
    }
    
    func strokeCircle(circle: Circle) {
        let rect = getRectFromCircle(circle)
        let path = UIBezierPath(ovalInRect: rect)
        // UIColor.greenColor().setFill()
        path.fill()
    }
    
    override func drawRect(rect: CGRect) {
        finishedCircleColor.setFill()
        for circle in finishedCircles {
            strokeCircle(circle)
        }

        currentCircleColor.setFill()
        for (_,circle) in currentCircles{
            strokeCircle(circle)
        }
    }
    
    //
    // MARK: - touch handlers
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // let us print a log statement
        print(#function)
        
        for touch in touches {
            let location = touch.locationInView(self)
            let newCircle = Circle(loc: location, diameter:  1)
            
            let key = NSValue(nonretainedObject: touch)
            
            currentCircles[key] = newCircle
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // let us print a log statement
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let loc = currentCircles[key]?.loc
            let newDiameter = getNewDiameter(loc!, newLocation: touch.locationInView(self))
            currentCircles[key]?.diameter = newDiameter
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            if var circle = currentCircles[key] {
                let loc = currentCircles[key]?.loc
                circle.diameter = getNewDiameter(loc!, newLocation: touch.locationInView(self))
                finishedCircles.append(circle)
                currentCircles.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(#function)
        
        currentCircles.removeAll()
        
        setNeedsDisplay()
    }
    
}
