//
//  Tools.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 02/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import Foundation
import UIKit

class Tools{
    
    func conFormatoCurrency(cantidad:Double)-> String{
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        var val:String = "\(cantidad)"
        // Max Value
        val = formatter.stringFromNumber(cantidad)!
        return val
    }
    
    /*
        TAMAÑO DE LA FUENTE DE ACUERDO AL HEIGH DEL LABEL
    */
    func optimisedfindAdaptiveFontWithName(fontName:String, label:UILabel!, minSize:CGFloat,maxSize:CGFloat) -> UIFont!{
        
        var tempFont:UIFont
        var tempHeight:CGFloat
        var tempMax:CGFloat = maxSize
        var tempMin:CGFloat = minSize
        
        while (ceil(tempMin) != ceil(tempMax)){
            let testedSize = (tempMax + tempMin) / 2
            
            
            tempFont = UIFont(name:fontName, size:testedSize)!
            let attributedString = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName : tempFont])
            
            let textFrame = attributedString.boundingRectWithSize(CGSize(width: label.bounds.size.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin , context: nil)
            
            let difference = label.frame.height - textFrame.height
            //println("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")
            if(difference > 0){
                tempMin = testedSize
            }else{
                tempMax = testedSize
            }
        }
        
        
        //returning the size -1 (to have enought space right and left)
        return UIFont(name: fontName, size: tempMin - 1)
    }
    
}