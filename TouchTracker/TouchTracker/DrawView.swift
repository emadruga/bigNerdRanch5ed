//
//  DrawView.swift
//  TouchTracker
//
//  Created by Ewerton Madruga on 5/23/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    let color1 : UIColor = UIColor.magentaColor()
    let color2 : UIColor = UIColor.redColor()
    let color3 : UIColor = UIColor.blueColor()
    let color4 : UIColor = UIColor.greenColor()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    func getLineAngle(line: Line) -> CGFloat {
        let Pi = CGFloat(M_PI)
        let radians2Degrees = 180 / Pi
        let deltaX = line.begin.x - line.end.x
        let deltaY = line.begin.y - line.end.y
        
        // atan2 returns radian angles [-Pi,Pi):
        //   negatives when line is drawn upward
        var angle = atan2(deltaY, deltaX) * radians2Degrees
        
        // angle is in degrees: [0, 360)
        angle = (angle < 0) ? (360 + angle) : angle
        
        return angle
    }
    
    func colorByAngle(line: Line) -> UIColor {
        
        let angle = getLineAngle(line)
        
        var response = UIColor.redColor()
        if angle <= 90 {
            response = self.color1
        } else
        if angle > 90 && angle <= 180 {
            response = self.color2
        } else if angle > 180 && angle <= 270 {
            response = self.color3
        } else {
            response = self.color4
        }
        return response
    }
    
    override func drawRect(rect: CGRect) {
        
        for line in finishedLines {
            finishedLineColor = colorByAngle(line)
            finishedLineColor.setStroke()
            strokeLine(line)
        }
        
        currentLineColor.setStroke()
        for (_,line) in currentLines {
            strokeLine(line)
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
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // let us print a log statement
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView(self)
        }

        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                
                let angle = getLineAngle(line)
                
                print ("Angle: \(angle)")
                
                finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
}
