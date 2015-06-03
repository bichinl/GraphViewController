//
//  Bank.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import Foundation

public class Bank{
    
    var _id:String!
    var id:String {
        get {
            return _id
        }
        set (newVal) {
            _id = newVal
        }
    }
    
    var _titulo:String!
    var titulo:String {
        get {
            return _titulo
        }
        set (newVal) {
            _titulo = newVal
        }
    }
    
    var _cantidad:Double!
    var cantidad:Double {
        get {
            return _cantidad
        }
        set (newVal) {
            _cantidad = newVal
        }
    }
    
    var _concepto:String!
    var concepto:String {
        get {
            return _concepto
        }
        set (newVal) {
            _concepto = newVal
        }
    }
    
    var _detalles:String!
    var detalles:String {
        get {
            return _detalles
        }
        set (newVal) {
            _detalles = newVal
        }
    }
    
    var _tipo:String!
    var tipo:String {
        get {
            return _tipo
        }
        set (newVal) {
            _tipo = newVal
        }
    }
    
    var _saldo:Double!
    var saldo:Double {
        get {
            return _saldo
        }
        set (newVal) {
            _saldo = newVal
        }
    }
    
    
    //    var id:String! = ""
    //    var titulo:String! = ""
    //    var cantidad:Double! = 0
    //    var concepto:String! = ""
    //    var detalles:String! = ""
    //
    //    init(id:String, titulo:String, cantidad:Double, concepto:String, detalles:String){
    //        self.id = id
    //        self.titulo = titulo
    //        self.cantidad = cantidad
    //        self.concepto = concepto
    //        self.detalles = detalles
    //    }
    
}