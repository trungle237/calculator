//
//  ViewController.swift
//  TrungCalculator
//
//  Created by Trung Le on 6/5/17.
//  Copyright © 2017 Trung Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func clickEquals(_ sender: UIButton) {
        if let result = Parser<Fraction>.evaluate(resultLabel.text!) {
            resultLabel.text = resultLabel.text! + " = " + result.description //resultLabel.text! +
        }
        else {
            resultLabel.text = "Error"
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "2/3+3/2"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

