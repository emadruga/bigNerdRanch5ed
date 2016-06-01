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
    var selectedLineIndex: Int?
    
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
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        
        currentLineColor.setStroke()
        for (_,line) in currentLines {
            strokeLine(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.greenColor().setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(selectedLine)
        }
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        // find a line close to a point
        for (index,line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            // check a few points on the line
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // if the tapped point is within 20 points, this the line to return
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // if nothing is close enough, we do not select a line
        return nil
    }
    
    //
    // MARK: - constructors & tap handlers
    //
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        print ("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        
        setNeedsDisplay()
    }
    
    func tap(gestureRecognizer: UIGestureRecognizer) {
        print ("Recognized a single tap")
        
        let point = gestureRecognizer.locationInView(self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(DrawView.doubleTap(_:)))
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)

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
