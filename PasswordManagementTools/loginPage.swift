//
//  loginPage.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/2.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SDCAlertView

class loginPage: UIViewController {

    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loginBtn.layer.cornerRadius = 10
        //userview
        let userView:UIView=UIView(frame: CGRect(x:0,y:0,width:19,height:14))
        let userPic:UIImageView=UIImageView(frame: CGRect(x:7,y:0,width:14,height:14));
        userPic.image = UIImage(named:"user.png")
        userView.addSubview(userPic)
        self.userPhone.leftView = userView
        self.userPhone.leftViewMode = UITextFieldViewMode.always
        //passview
        let passView:UIView=UIView(frame: CGRect(x:0,y:0,width:19,height:14))
        let passwordPic:UIImageView=UIImageView(frame: CGRect(x:7,y:0,width:14,height:14));
        passwordPic.image = UIImage(named:"password.png")
        passView.addSubview(passwordPic)
        self.userPassword.leftView = passView
        self.userPassword.leftViewMode = UITextFieldViewMode.always
        
    }
    @IBAction func login(_ sender: Any) {
        //alertView Controller
        let alert = AlertController(title: "title",message: "messgae", preferredStyle: .alert)
        alert.add(AlertAction(title: "确认",style:.preferred))
        //get the text of the textfield
        let name = userPhone.text
        let pass = userPassword.text
        if name == "" || pass == "" {
            alert.title = "用户名或密码为空"
            alert.message = "请输入用户名或密码"
            alert.present()
        }
        else{
            //query the database user
            let realm = try! Realm()
            let result = realm.objects(Users.self).filter(" u_name = '\(name!)' AND u_password = '\(pass!)' ")
            if result.count > 0 {
                let userCookie = UserDefaults.standard
                //username
                userCookie.set("\(name!)",forKey: "userName")
                //userpassword
                userCookie.set("\(pass!)",forKey: "userPass")
                self.performSegue(withIdentifier: "logintomain", sender: self)
            }
            else {
                alert.title = "登录失败"
                alert.message = "用户名或者密码错误，请重新登录"
                alert.present()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
