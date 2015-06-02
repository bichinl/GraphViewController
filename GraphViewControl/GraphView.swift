//
//  GraphView.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import UIKit

class GraphView: UIView {

    @IBInspectable var background:UIColor = UIColor(red: 0.320, green: 0.800, blue: 0.608, alpha: 1.000)
    @IBInspectable var strokeColor: UIColor = UIColor.whiteColor()
    @IBInspectable var topMargin: CGFloat = 30
    @IBInspectable var leftMargin: CGFloat = 90
    @IBInspectable var sidesMargins: CGFloat = 10
    @IBInspectable var bottomMargin: CGFloat = 50
    
    @IBInspectable var paddingTitleChart: CGFloat = 15
    
    @IBInspectable var horLines: Int = 4
    
    @IBInspectable var showChartEdges:Bool = true
    
    @IBInspectable var showVerticlaLines:Bool = true
    
    var listaBank:[Bank] = []
    
    var circleList:[GraphViewCircle] = []
    
    
    
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
    
    }
    
    override func drawRect(rect: CGRect) {
        if self.listaBank.count > 0 {
            self.drawCanvas1(rect)
        }
        
    }
    
    func drawCanvas1(mainFrame: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Variable Declarations
        let w: CGFloat = mainFrame.width
        let h: CGFloat = mainFrame.height
        let titleTextExpression = CGRectMake(sidesMargins, topMargin, w - sidesMargins * 2, 21)
        let chartAreaExpression = CGRectMake(leftMargin, topMargin + titleTextExpression.size.height + paddingTitleChart, w - leftMargin - sidesMargins, h - topMargin - bottomMargin - titleTextExpression.size.height)
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, w, h))
        background.setFill()
        rectanglePath.fill()
        
        
        //// lineCharts Drawing
        let lineChartsPath = UIBezierPath(rect: chartAreaExpression)
        //UIColor.lightGrayColor().setFill()
        lineChartsPath.fill()
        
        self.drawHorizontalLines(chartAreaExpression)
        if showVerticlaLines{
            self.drawVerticalLines(chartAreaExpression)
        }
        self.drawGraphLinesChart(chartAreaExpression)
        
        //// Text Drawing
        let textRect = CGRectMake(titleTextExpression.origin.x, titleTextExpression.origin.y, titleTextExpression.size.width, titleTextExpression.size.height)
        var textTextContent = NSString(string: "Hello, World \(maxCantidad)")
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(22/*UIFont.systemFontSize()*/), NSForegroundColorAttributeName: strokeColor, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        textTextContent.drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
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
                strokeColor.colorWithAlphaComponent(0.4).setStroke()
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
                strokeColor.colorWithAlphaComponent(0.4).setStroke()
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
            x += self.leftMargin
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
        UIColor.whiteColor().setStroke()
        graphPath.stroke()
        
        // Draw Circles
        let circleSize:CGSize = CGSize(width: 15, height: 15)
        var circle:GraphViewCircle = GraphViewCircle(frame: CGRect(origin: CGPoint(x: columnXPoint(0) - circleSize.width / 2, y: columnYPoint(p) - circleSize.height / 2), size: circleSize))
        circle.tag = 0
        circle.emptyColor = background
        circle.addTarget(self, action: "circlePress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(circle)
        self.circleList.append(circle)
        for i in 1...self.listaBank.count - 1 {
            let p:Int = Int(listaBank[i].cantidad)
            //let p:Int = Int(listaBank[i])
            let nextPoint = CGPoint(x:columnXPoint(i) - circleSize.width / 2, y:columnYPoint(p) - circleSize.height / 2)
            
            var circle:GraphViewCircle = GraphViewCircle(frame: CGRect(origin: nextPoint, size: circleSize))
            circle.tag = i
            circle.emptyColor = background
            circle.addTarget(self, action: "circlePress:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(circle)
            self.circleList.append(circle)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if listaBank.count > 0 {
            maxCantidad = Double(maxElement(listaBank.map{$0.cantidad}))
            //maxCantidad = Double(maxElement(listaBank))
            println("maxCantidad: \(maxCantidad)")
            
            minCantidad = Double(minElement(listaBank.map{$0.cantidad}))
            //minCantidad = Double(minElement(listaBank))
            println("minCantidad: \(minCantidad)")
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
    }
}
