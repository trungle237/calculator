//
//  ViewController.swift
//  TrungCalculator
//
//  Created by Trung Le on 6/5/17.
//  Copyright © 2017 Trung Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var result: UILabel!
    
    
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
    result.text = result.text! + String(sender.tag-1)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

