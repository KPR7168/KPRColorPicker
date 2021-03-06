//
//  ViewController.swift
//  KPRColorPicker-Example
//
//  Created by Ky Pichratanak on 11/12/16.
//  Copyright © 2016 Ky Pichratanak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KPRColorPickerDelegate {

    private var picker : KPRColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker = KPRColorPicker.init()
        picker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonTouched(_ sender: Any) {
        self.present(picker, animated: true, completion: nil)
    }
    
    func KPRColorPickerDidSelectWithUIColor(_ sender: UIColor){
        self.view.backgroundColor = sender
    }
}

