//
//  uploadImage.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/9.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import JavaScriptCore
import RealmSwift

class uploadImage: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    
    let defaultname = UserDefaults.standard.string(forKey: "userName")
    
    //初始化图片选择器控制器
    let pick: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.dismiss(animated: true, completion: nil)
        imageView.layer.cornerRadius = 112
        imageView.layer.masksToBounds = true
        //query the data
        let query = try! Realm()
        let User = query.objects(Users.self).filter(" u_name = '\(self.defaultname!)' ").first
        if User?.u_pictrue != nil {
            imageView.image = UIImage(data: User?.u_pictrue as! Data)
        } else {
            imageView.image = UIImage(named: "default224.png")
        }
            userNameTextField.text = User?.u_name
            userPhoneTextField.text = User?.u_phone
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func backToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "backToMain", sender: self)
    }
    @IBAction func confirmChange(_ sender: Any) {
        let nameText = userNameTextField.text
        let phoneText = userPhoneTextField.text
        try! Realm().objects(Users.self).filter(" u_name = '\(self.defaultname)' ").first?.u_name = nameText!
        try! Realm().objects(Users.self).filter(" u_name = '\(self.defaultname)' ").first?.u_phone = phoneText!
        backToMain(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getSystemPhoto(_ sender: UIButton) {
        //设置代理
        self.pick.delegate = self
        self.pick.allowsEditing = true
        self.pick.sourceType = .photoLibrary
        self.present(pick, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //选择照片
        pick.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //把图片转为NSData
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        //let data = UIImagePNGRepresentation(imageView.image!)
        //将图片存储在数据库中
        let realm = try! Realm()
        let theUser = realm.objects(Users.self).filter("u_name = '\(self.defaultname!)'").first
        try! realm.write {
            theUser?.u_pictrue = data! as NSData
        }
        //alaomfire上传
        let token = "sYLzF9HTC_ALE4YX-XzQy5vu0WS7IF1gqvkfLZDr:2dGk6ySG4SNJjluF5lTatK0W2IQ=:eyJzY29wZSI6InVzZXJpbWFnZXMiLCJkZWFkbGluZSI6MTU4NjUyNDc1OX0="
        let tokendata = token.data(using: String.Encoding.utf8, allowLossyConversion: true)
        upload(multipartFormData: { multipartFormData in
            multipartFormData.append(tokendata!, withName: "token")
            multipartFormData.append(data!, withName: "file")
        },
               to: "http://up-z2.qiniu.com",
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}
