//
//  ViewController.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let firebaseUrl:FirebaseUrl = FirebaseUrl()
    let constants:Constants = Constants()
    
    @IBOutlet var graphView: GraphView!
    
    var listBank = [Bank]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.graphView.background = UIColor.grayColor()
//        self.graphView.textColor = UIColor.blackColor()
        
        //var values:[Double] = [20,15,8,50,3]
        var listaBank:[Bank] = []
        for i in 0...7{
            var bank:Bank = Bank()
            //bank.cantidad = Double(values[i])
            let randomNumber = arc4random_uniform(35000)
            bank.cantidad = Double(randomNumber)
            bank.tipo = "Salidas \(i)"
            //println("Bank tipo: \(bank.tipo); cantidad: \(bank.cantidad)")
            listaBank.append(bank)
        }
        
        graphView.listaBank = listaBank
        
        self.checarSaldo()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getFromFirebase()
    }
    
    func checarSaldo(){
        let ref = Firebase(url: "\(self.firebaseUrl.FIREBASE)/bank/saldo")
        var existeSaldo:Bool = false
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var children = snapshot.children
            while let child = children.nextObject() as? FDataSnapshot {
                if child.key == "saldo"{
                    MySingleton.sharedInstance.saldo = child.value as! Double
                    existeSaldo = true
                }
            }
            if !existeSaldo{
                self.inicializarCuenta()
            }
            }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
    func inicializarCuenta(){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Cuenta actual",
            message: "Actualmente no se tiene informacion sobre cuanto dinero existe en la cuenta, favor de ingresar la cantidad.",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.keyboardType = UIKeyboardType.NumberPad
                textField.placeholder = "Ingrese la cantidad"
        })
        
        let action = UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    println("enteredText: \(enteredText)")
                    
                    let date = NSDate()
                    let timestamp:String = "\(date.timeIntervalSince1970*1000)"
                    
                    var ref = Firebase(url: self!.firebaseUrl.FIREBASE+"/bank")
                    var movement = ["saldo": (enteredText as NSString).doubleValue, "date":timestamp]
                    var bankRef = ref.childByAppendingPath("saldo")
                    
                    bankRef.setValue(movement, withCompletionBlock: {
                        (error:NSError?, ref:Firebase!) in
                        if (error != nil) {
                            var alert = UIAlertView(title: "Error", message: "Hubo un error al intentar guardar, vuelva a intentarlo.", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
                        }else{
                            MySingleton.sharedInstance.saldo = (enteredText as NSString).doubleValue
                        }
                    })
                }
            })
        
        
        alertController?.addAction(action)
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alertController!,animated: true,completion: nil)
        }
    }
    
    func getFromFirebase(){
        let ref = Firebase(url: "\(self.firebaseUrl.FIREBASE)/bank/movements")
        ref.queryOrderedByChild("date").observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.sacarItemsOnetime(snapshot)
        })
    }
    
    func sacarItemsOnetime(snapshot:FDataSnapshot){
        var children = snapshot.children
        while let child = children.nextObject() as? FDataSnapshot {
            var bank = Bank()
            bank.id = child.key
            for (key, value) in child.value as! NSDictionary{
                switch(key as! String){
                case "titulo":
                    bank.titulo = value as! String
                    break
                case "cantidad":
                    var val = value as! Double
                    bank.cantidad = val //Double((value as NSString).doubleValue)
                    break
                case "concepto":
                    bank.concepto = value as! String
                    break
                case "detalles":
                    bank.detalles = value as! String
                    break
                case "tipo":
                    bank.tipo = value as! String
                    break
                case "saldo":
                    bank.saldo = value as! Double
                    break
                default:
                    break
                }
            }
            
            self.listBank.append(bank)
            MySingleton.sharedInstance.bankMovements.append(bank)
        }
        
        if self.listBank.count > constants.MAX_NUMBER_GRAPHIC_POINTS {
            for i in (self.listBank.count - (self.constants.MAX_NUMBER_GRAPHIC_POINTS))...self.listBank.count - 1{
                var bank = self.listBank[i]
                var cant = Int(bank.cantidad)
                println("cantidad: \(cant)")
            }
        }
        
        self.listBank = self.listBank.reverse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

