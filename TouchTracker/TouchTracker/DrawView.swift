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
    
    var refLocation : CGPoint = CGPoint.zero
    var refKey : NSValue = 0
    var refTouchCount = 0
    
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
        print("\(#function) : \(touches.count)")
        
        for touch in touches {
            refTouchCount += 1
            if refKey == 0 {
                // 1 - There was no previous touch
                
                refLocation = touch.locationInView(self)
                refKey = NSValue(nonretainedObject: touch)
            } else {
                // 2 - There was a previous touch
                // Time to start making some circles...
                
                let location = touch.locationInView(self)
                let diam     = getNewDiameter(refLocation, newLocation: location)
                let newCircle = Circle(loc: location, diameter:  diam)
            
                let key = NSValue(nonretainedObject: touch)
            
                currentCircles[key] = newCircle
            }
        }
    
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // let us print a log statement
        print("\(#function) : \(touches.count)")
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if key != refKey {
                let loc = touch.locationInView(self)
                let newDiameter = getNewDiameter(refLocation, newLocation: loc)
                currentCircles[key]?.loc = loc
                currentCircles[key]?.diameter = newDiameter
            } else {
                refLocation = touch.locationInView(self)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(#function) : \(touches.count)")
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)

            refTouchCount -= 1
            
            if key != refKey {
                if var circle = currentCircles[key] {
                    let loc = touch.locationInView(self)
                    circle.diameter = getNewDiameter(refLocation,
                                                     newLocation: loc)
                    finishedCircles.append(circle)
                    currentCircles.removeValueForKey(key)
                }
            } else {
                refLocation = touch.locationInView(self)
            }
            
        }
        if refTouchCount == 0 {
            refKey = 0
            refLocation = CGPoint.zero
        }

        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(#function)
        
        currentCircles.removeAll()
        
        setNeedsDisplay()
    }
    
    
}
