//
//  MySingleton.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 02/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import Foundation

class MySingleton {
    class var sharedInstance : MySingleton {
        struct _Singleton {
            static let instance = MySingleton()
        }
        return _Singleton.instance
    }
    
    var bank:Bank!
    
    var bankMovements = [Bank]()
    
    var saldo:Double = 0
    
}