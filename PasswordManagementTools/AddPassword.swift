//
//  AddPassword.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/1/30.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SDCAlertView

class AddPassword: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup avarr loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var aName: UITextField!
    @IBOutlet weak var aAccount: UITextField!
    @IBOutlet weak var aPassword: UITextField!
    
    let defaultname = UserDefaults.standard.string(forKey: "userName")
    
    @IBAction func aSave(_ sender: UIButton) {
        //alertView Controller
        let alert = AlertController(title: "title",message: "messgae", preferredStyle: .alert)
        alert.add(AlertAction(title: "",style:.normal))
        alert.add(AlertAction(title: "确认",style:.preferred))
        //judge
        if aName.text == "" {
            alert.title = "名称不能为空!"
            alert.message = "请输入名称"
            alert.present()
        }
        else {
            let name = aName.text
            if aAccount.text == "" {
                alert.title = "账号不能为空!"
                alert.message = "请输入账号"
                alert.present()
            }
            else {
                let account = aAccount.text
                if aPassword.text == "" {
                    alert.title = "密码不能为空!"
                    alert.message = "请输入密码"
                    alert.present()
                }
                else {
                    let password = aPassword.text
                    //use the data
                    let passwords = Passwords()
                    passwords.p_number = passwords.IncrementaID()
                    passwords.p_name = name!
                    passwords.p_account = account!
                    passwords.p_password = password!
                    passwords.p_owner = "\(self.defaultname!)"
                    //add the data
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(passwords)
                    }
                    //add the data to the user
                    let theUser = realm.objects(Users.self).filter("u_name = '\(UserDefaults.standard.string(forKey: "userName"))'").first
                    try! realm.write {
                        theUser?.Passwords.append(passwords)
                    }
                    //return to mainpage
                    self.performSegue(withIdentifier: "saveSuccess", sender: self)
                }
            }
        }
    }
}

