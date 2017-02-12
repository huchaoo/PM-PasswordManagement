//
//  signinPage.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/2.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SDCAlertView

class signinPage: UIViewController {
    
    @IBOutlet weak var signinName: UITextField!
    @IBOutlet weak var signinPhone: UITextField!
    @IBOutlet weak var signinPassword: UITextField!
    
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.signinBtn.layer.cornerRadius = 10
        // nameView
        let nameView:UIView=UIView(frame: CGRect(x:0,y:0,width:19,height:14))
        let namePic:UIImageView=UIImageView(frame: CGRect(x:7,y:0,width:14,height:14));
        namePic.image = UIImage(named:"user.png")
        nameView.addSubview(namePic)
        self.signinName.leftView = nameView
        self.signinName.leftViewMode = UITextFieldViewMode.always
        // phoneView
        let phoneView:UIView=UIView(frame: CGRect(x:0,y:0,width:19,height:14))
        let phonePic:UIImageView=UIImageView(frame: CGRect(x:7,y:0,width:14,height:14));
        phonePic.image = UIImage(named:"phone.png")
        phoneView.addSubview(phonePic)
        self.signinPhone.leftView = phoneView
        self.signinPhone.leftViewMode = UITextFieldViewMode.always
        // passView
        let passView:UIView=UIView(frame: CGRect(x:0,y:0,width:19,height:14))
        let passPic:UIImageView=UIImageView(frame: CGRect(x:7,y:0,width:14,height:14));
        passPic.image = UIImage(named:"password.png")
        passView.addSubview(passPic)
        self.signinPassword.leftView = passView
        self.signinPassword.leftViewMode = UITextFieldViewMode.always
    }
    
    @IBAction func signIn(_ sender: Any) {
        //alertView Controller
        let alert = AlertController(title: "title",message: "messgae", preferredStyle: .alert)
        alert.add(AlertAction(title: "确认",style:.preferred))
        //get the text of the textfield
        let name = signinName.text
        let phone = signinPhone.text
        let password = signinPassword.text
        if name == "" || phone == "" || password == "" {
            alert.title = "信息不能为空"
            alert.message = "请输入用户名、手机号以及密码"
            alert.present()
        }
        else{
            //use the data
            let user = Users()
            user.u_name = name!
            user.u_phone = phone!
            user.u_password = password!
            //get the default realm
            let realm = try! Realm()
            //add the data
            try! realm.write {
                realm.add(user)
            }
            self.performSegue(withIdentifier: "signinSuccess", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
