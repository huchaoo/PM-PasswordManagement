//
//  detailPasswords.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/12.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit

class detailPasswords: UIViewController {
    
    var items: Passwords? = nil
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var accpunt: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.image.image = UIImage(named: "lock.png")
        self.name.text = "名称：" + (items?.p_name)!
        self.accpunt.text = "账号：" + (items?.p_account)!
        self.password.text = "密码：" + (items?.p_password)!
    }
    
    @IBAction func backtomain(_ sender: Any) {
        self.performSegue(withIdentifier: "detailTomain", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
