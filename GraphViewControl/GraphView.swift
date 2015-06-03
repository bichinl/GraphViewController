//
//  GraphView.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    let tools:Tools = Tools()
    
    @IBInspectable var titleTextString:String! = "Component Name"
    @IBInspectable var background:UIColor = UIColor(red: 0.320, green: 0.800, blue: 0.608, alpha: 1.000)
    @IBInspectable var textColor: UIColor = UIColor.whiteColor()
    @IBInspectable var marginTop: CGFloat = 30
    @IBInspectable var marginLeft: CGFloat = 85
    @IBInspectable var marginRight: CGFloat = 20
    @IBInspectable var marginBottom: CGFloat = 10
    
    let titleHeight: CGFloat = 21
    let marginTitle: CGFloat = 20

    let detailHeight: CGFloat = 16
    let marginDetail: CGFloat = 10
    
    var valuesHeight: CGFloat = 14
    
    var maxValueString:String = "maxValue"
    var minValueString:String = "minValue"
    
    @IBInspectable var horLines: Int = 4
    
    @IBInspectable var showChartEdges:Bool = true
    
    @IBInspectable var showVerticlaLines:Bool = true
    
    var listaBank:[Bank] = []
    
    var circleList:[GraphViewCircle] = []
    
    var detailTextString:String! = "The details here!"
    
    var finalDetailTextRect:CGRect!
    
    var detailLabel:UILabel = UILabel()
    
    //var listaBank:[Double] = [0,10,5,5,15]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    var maxCantidad:Double! = 0
    var minCantidad:Double! = 0
    
    func setup(){
        println("[--- setup ---]")
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.listaBank.count > 0 {
            self.drawGrapViewComponen(rect)
        }
        
    }
    
    func drawGrapViewComponen(rect:CGRect) {
        println("[--- drawCanvas1 ---]")
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        
        //// Variable Declarations
        let w: CGFloat = rect.width
        let triangleX: CGFloat = w / 2.0 - 15
        let h: CGFloat = rect.height
        let hTriangle: CGFloat = 15
        let wRectangle: CGFloat = h - hTriangle
        let triangleY: CGFloat = wRectangle
        let titleRectExpression = CGRectMake(marginRight, marginTop, w - marginRight * 2, titleHeight)
        
        let graphContainerExpression = CGRectMake(marginLeft, marginTop + titleHeight + marginTitle, w - marginLeft - marginRight, h - marginTop - titleHeight - marginTitle - marginDetail - detailHeight - marginBottom - hTriangle)
        let detailRectExpression = CGRectMake(marginRight, h - detailHeight - marginBottom - hTriangle, w - marginRight * 2, detailHeight)
        let maxValueExpression = CGRectMake(10, graphContainerExpression.origin.y, graphContainerExpression.origin.x - marginRight - 0, valuesHeight)
        let minValueExpression = CGRectMake(10, graphContainerExpression.size.height + graphContainerExpression.origin.y - valuesHeight, graphContainerExpression.origin.x - marginRight - 0, valuesHeight)
        
        //// Frames
        let frame = CGRectMake(0, 0, w, h)
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, w, wRectangle))
        background.setFill()
        rectanglePath.fill()
        
        
        //// Polygon Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, triangleX, triangleY)
        
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(15, 15))
        polygonPath.addLineToPoint(CGPointMake(30, 0))
        polygonPath.addLineToPoint(CGPointMake(0, 0))
        polygonPath.addLineToPoint(CGPointMake(15, 15))
        polygonPath.closePath()
        background.setFill()
        polygonPath.fill()
        
        CGContextRestoreGState(context)
        
        
        //// detailText Drawing
        let detailTextRect = CGRectMake(detailRectExpression.origin.x, detailRectExpression.origin.y, detailRectExpression.size.width, detailRectExpression.size.height)
        self.finalDetailTextRect = detailTextRect
        
//        var detailTextTextContent = "Detail should appear here!"
//        let detailTextStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
//        detailTextStyle.alignment = NSTextAlignment.Center
//        
//        let detailTextFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize()), NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: detailTextStyle]
//        
//        let detailTextTextHeight: CGFloat = detailTextTextContent.boundingRectWithSize(CGSizeMake(detailTextRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: detailTextFontAttributes, context: nil).size.height
//        CGContextSaveGState(context)
//        CGContextClipToRect(context, detailTextRect);
//        detailTextTextContent.drawInRect(CGRectMake(detailTextRect.minX, detailTextRect.minY + (detailTextRect.height - detailTextTextHeight) / 2, detailTextRect.width, detailTextTextHeight), withAttributes: detailTextFontAttributes)
//        CGContextRestoreGState(context)
        
        
        //// graphContainer Drawing
        let graphContainerPath = UIBezierPath(rect: graphContainerExpression)
        //UIColor.grayColor().setFill()
        graphContainerPath.fill()
        
        self.drawHorizontalLines(graphContainerExpression)
        if showVerticlaLines{
            self.drawVerticalLines(graphContainerExpression)
        }
        self.drawGraphLinesChart(graphContainerExpression)

        
        
        //// minText Drawing
        let minTextRect = CGRectMake(minValueExpression.origin.x, minValueExpression.origin.y, minValueExpression.size.width, minValueExpression.size.height)
        var minTextTextContent = self.minValueString
        let minTextStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        minTextStyle.alignment = NSTextAlignment.Right
        
        let minTextFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: minTextStyle]
        
        let minTextTextHeight: CGFloat = minTextTextContent.boundingRectWithSize(CGSizeMake(minTextRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: minTextFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, minTextRect);
        minTextTextContent.drawInRect(CGRectMake(minTextRect.minX, minTextRect.minY + (minTextRect.height - minTextTextHeight) / 2, minTextRect.width, minTextTextHeight), withAttributes: minTextFontAttributes)
        CGContextRestoreGState(context)
        
        
        //// maxText Drawing
        let maxTextRect = CGRectMake(maxValueExpression.origin.x, maxValueExpression.origin.y, maxValueExpression.size.width, maxValueExpression.size.height)
        var maxTextTextContent = self.maxValueString
        let maxTextStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        maxTextStyle.alignment = NSTextAlignment.Right
        
        let maxTextFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: maxTextStyle]
        
        let maxTextTextHeight: CGFloat = maxTextTextContent.boundingRectWithSize(CGSizeMake(maxTextRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: maxTextFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, maxTextRect);
        maxTextTextContent.drawInRect(CGRectMake(maxTextRect.minX, maxTextRect.minY + (maxTextRect.height - maxTextTextHeight) / 2, maxTextRect.width, maxTextTextHeight), withAttributes: maxTextFontAttributes)
        CGContextRestoreGState(context)
        
        
        //// titleText Drawing
        let titleTextRect = CGRectMake(titleRectExpression.origin.x, titleRectExpression.origin.y, titleRectExpression.size.width, titleRectExpression.size.height)
        var titleTextTextContent = self.titleTextString
        let titleTextStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        titleTextStyle.alignment = NSTextAlignment.Center
        
        let titleTextFontAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(UIFont.systemFontSize()), NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: titleTextStyle]
        
        let titleTextTextHeight: CGFloat = titleTextTextContent.boundingRectWithSize(CGSizeMake(titleTextRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleTextFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, titleTextRect);
        titleTextTextContent.drawInRect(CGRectMake(titleTextRect.minX, titleTextRect.minY + (titleTextRect.height - titleTextTextHeight) / 2, titleTextRect.width, titleTextTextHeight), withAttributes: titleTextFontAttributes)
        CGContextRestoreGState(context)
    }
    
    func drawHorizontalLines(rect:CGRect){
        if horLines >= 3{
            let segment:CGFloat = (rect.height) / CGFloat(horLines - 1)
            for i in 0...horLines - 1 {
                let posY = (CGFloat(i) * segment) + rect.origin.y
                var bezierPath = UIBezierPath()
                bezierPath.moveToPoint(CGPointMake(rect.origin.x, posY))
                bezierPath.addLineToPoint(CGPointMake(rect.width + rect.origin.x, posY))
                textColor.colorWithAlphaComponent(0.4).setStroke()
                bezierPath.lineWidth = 1
                if !showChartEdges && (i == 0 || i == horLines - 1){
                    
                }else{
                    bezierPath.stroke()
                }
            }
        }
    }
    
    func drawVerticalLines(rect:CGRect){

        if listaBank.count >= 3{
            let segment:CGFloat = (rect.width) / CGFloat(listaBank.count - 1)
            for i in 0...listaBank.count - 1 {
                let posX = (CGFloat(i) * segment) + rect.origin.x
                var bezierPath = UIBezierPath()
                bezierPath.moveToPoint(CGPointMake(posX, rect.origin.y))
                bezierPath.addLineToPoint(CGPointMake(posX, rect.height + rect.origin.y))
                textColor.colorWithAlphaComponent(0.4).setStroke()
                bezierPath.lineWidth = 1
                if !showChartEdges && (i == 0 || i == listaBank.count - 1){
                    
                }else{
                    bezierPath.stroke()
                }
            }
        }
    }
    
    func drawGraphLinesChart(rect:CGRect){
        var width:CGFloat = rect.width
        var height:CGFloat = rect.height
        
        var columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width) / CGFloat(self.listaBank.count - 1)
            var x:CGFloat = CGFloat(column) * spacer
            x += self.marginLeft
            return x
        }
        
        let graphHeight = height
        var columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(self.maxCantidad) * graphHeight
            y = graphHeight + rect.origin.y - y
            return y
        }
        
        //set up the points line
        var graphPath = UIBezierPath()
        
        //set up stroke thick
        graphPath.lineWidth = 2
        
        //go to start of line
        var p:Int = Int(listaBank[0].cantidad)
        //var p:Int = Int(listaBank[0])
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(p)))
        
        for i in 1...self.listaBank.count - 1 {
            let p:Int = Int(listaBank[i].cantidad)
            //let p:Int = Int(listaBank[i])
            let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(p))
            graphPath.addLineToPoint(nextPoint)
        }
        textColor.setStroke()
        graphPath.stroke()
        
        // Draw Circles
        let circleSize:CGSize = CGSize(width: 15, height: 15)
        var circle:GraphViewCircle = GraphViewCircle(frame: CGRect(origin: CGPoint(x: columnXPoint(0) - circleSize.width / 2, y: columnYPoint(p) - circleSize.height / 2), size: circleSize))
        circle.tag = 0
        circle.emptyColor = background
        circle.filledColor = textColor
        circle.addTarget(self, action: "circlePress:", forControlEvents: UIControlEvents.TouchUpInside)
        circle.isFilled = true
        self.addSubview(circle)
        self.circleList.append(circle)
        
        for i in 1...self.listaBank.count - 1 {
            let p:Int = Int(listaBank[i].cantidad)
            //let p:Int = Int(listaBank[i])
            let nextPoint = CGPoint(x:columnXPoint(i) - circleSize.width / 2, y:columnYPoint(p) - circleSize.height / 2)
            
            var circle:GraphViewCircle = GraphViewCircle(frame: CGRect(origin: nextPoint, size: circleSize))
            circle.tag = i
            circle.emptyColor = background
            circle.filledColor = textColor
            circle.addTarget(self, action: "circlePress:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(circle)
            self.circleList.append(circle)
        }
    }
    
    override func layoutSubviews() {
        println("[--- layoutSubviews ---]")
        super.layoutSubviews()
        
        //self.backgroundColor = UIColor.clearColor()
        
        if listaBank.count > 0 {
            maxCantidad = Double(maxElement(listaBank.map{$0.cantidad}))
            //maxCantidad = Double(maxElement(listaBank))
            println("maxCantidad: \(maxCantidad)")
            self.maxValueString = "\(self.tools.conFormatoCurrency(maxCantidad))"
            
            minCantidad = Double(minElement(listaBank.map{$0.cantidad}))
            //minCantidad = Double(minElement(listaBank))
            println("minCantidad: \(minCantidad)")
            self.minValueString = self.tools.conFormatoCurrency(0)
            
            self.detailTextString = "Cantidad \(self.tools.conFormatoCurrency(listaBank[0].cantidad))"
        }
        
        if self.finalDetailTextRect != nil {
            self.detailLabel.frame = self.finalDetailTextRect
            self.detailLabel.text = self.detailTextString
            self.detailLabel.textAlignment = NSTextAlignment.Center
            self.detailLabel.textColor = self.textColor
            self.detailLabel.backgroundColor = self.background

            self.detailLabel.font = self.tools.optimisedfindAdaptiveFontWithName("Helvetica", label: self.detailLabel, minSize: 12, maxSize: 38)
            //println("\(self.detailLabel.font)")

            self.addSubview(self.detailLabel)
        }

        
    }
    
    func circlePress(sender:GraphViewCircle){
        var btnsendtag:UIButton = sender
        let tag = sender.tag
        println("sender: \(sender)")
        
        for circle in circleList{
            circle.isFilled = false
            circle.setNeedsDisplay()
        }
        
        circleList[tag].isFilled = true
        circleList[tag].setNeedsDisplay()
        
        self.detailLabel.text = "Cantidad \( self.tools.conFormatoCurrency(listaBank[tag].cantidad))"
    }
    
    

}
