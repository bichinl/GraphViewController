//
//  ViewController.swift
//  GraphViewControl
//
//  Created by Samuel Montes de Oca on 01/06/15.
//  Copyright (c) 2015 SourCode WebCreative. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var graphView: GraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var values:[Double] = [20,15,0,50,3]
        var listaBank:[Bank] = []
        for i in 0...4{
            var bank:Bank = Bank()
            bank.cantidad = Double(values[i])
            bank.tipo = "Salidas \(i)"
            println("Bank tipo: \(bank.tipo); cantidad: \(bank.cantidad)")
            listaBank.append(bank)
        }
        
        graphView.listaBank = listaBank
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

