//
//  aboutus.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/12.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit

class aboutus: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func aboutusTomain(_ sender: Any) {
        self.performSegue(withIdentifier: "aboutusTomain", sender: self)
    }
    
}
