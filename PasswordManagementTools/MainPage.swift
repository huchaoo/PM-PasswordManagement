//
//  MainPage.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/1/30.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell
import RealmSwift
import PopupDialog
import PermissionScope

class MainPage: UIViewController, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userName: UIButton!
    //emptyView
    @IBOutlet weak var emptyView: UIView!
    
    //permissionScope
    let pscope = PermissionScope()
    
    //save the result
    var result: Results<Passwords>?
    var userphoto: Results<Users>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyView.isHidden = true
        // Set up permissions
        pscope.addPermission(PhotosPermission(),
                             message: "We use this to steal\r\nyour friends")
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
        // Do any additional setup after loading the view, typically from a nib.
        let name = UserDefaults.standard.string(forKey: "userName")
        if  name != nil {
            self.userName.layer.borderColor = UIColor.clear.cgColor
            self.userName.layer.borderWidth = 1
            self.userName.layer.cornerRadius = 16
            self.userName.layer.masksToBounds = true
            //query the data from database
            let realm = try! Realm()
            result = realm.objects(Passwords.self).filter("p_owner = '\(name!)'")
            //get the UserDefaultValue photo
            let image = realm.objects(Users.self).filter("u_name = '\(name!)'").first?.u_pictrue
            if image == nil {
                self.userName.setImage(UIImage(named: "default.png"), for: .normal)
            }
            else {
                self.userName.setImage(UIImage(data: image as! Data), for: .normal)
            }
        }
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toSidebar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSidebar", sender: self)
    }
    
    //required method :to loading the datasource    if use  MGSwipeTableCell then override this method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MGSwipeTableCell!
        let items = self.result![indexPath.row]
        cell!.textLabel?.text = "账户名称: " + items.p_name
        cell!.textLabel?.font = UIFont(name: "Helvetica", size: 20.0)
        cell!.detailTextLabel?.text = "账户号: " + items.p_account
        cell!.detailTextLabel?.textColor = UIColor.gray
        cell!.detailTextLabel?.font = UIFont(name: "Helvetica" ,size: 14.0)
        let defaultname = items.p_name
        if (defaultname.range(of: "银行卡") != nil) {
            cell!.imageView?.image = UIImage(named:"yinhangka.png")
        } else if (defaultname.range(of: "淘宝") != nil) {
            cell!.imageView?.image = UIImage(named:"taobao.png")
        } else if (defaultname.range(of: "支付宝") != nil) {
            cell!.imageView?.image = UIImage(named:"zhifubao.png")
        } else if (defaultname.range(of: "美团") != nil) {
            cell!.imageView?.image = UIImage(named:"meituan.png")
        } else if (defaultname.range(of: "QQ") != nil) || (defaultname.range(of: "qq") != nil) || (defaultname.range(of: "腾讯") != nil){
            cell!.imageView?.image = UIImage(named:"QQ.png")
        } else if (defaultname.range(of: "微信") != nil) {
            cell!.imageView?.image = UIImage(named:"wechat.png")
        } else if (defaultname.range(of: "Adobe") != nil) {
            cell!.imageView?.image = UIImage(named:"adobe.png")
        } else if (defaultname.range(of: "学信网") != nil) {
            cell!.imageView?.image = UIImage(named:"xuexinwang.png")
        } else if (defaultname.range(of: "12306") != nil) {
            cell!.imageView?.image = UIImage(named:"12306.png")
        } else if (defaultname.range(of: "网易") != nil) {
            cell!.imageView?.image = UIImage(named:"netease.png")
        } else if (defaultname.range(of: "谷歌") != nil) || (defaultname.range(of: "Google") != nil) || (defaultname.range(of: "google") != nil){
            cell!.imageView?.image = UIImage(named:"google.png")
        } else if (defaultname.range(of: "github") != nil) || (defaultname.range(of: "Github") != nil){
            cell!.imageView?.image = UIImage(named:"github.png")
        } else if (defaultname.range(of: "知乎") != nil) {
            cell!.imageView?.image = UIImage(named:"zhihu.png")
        } else if (defaultname.range(of: "Apple") != nil) || (defaultname.range(of: "apple") != nil) || (defaultname.range(of: "苹果") != nil) {
            cell!.imageView?.image = UIImage(named:"apple.png")
        } else if (defaultname.range(of: "百度") != nil) {
            cell!.imageView?.image = UIImage(named:"baidu.png")
        } else if (defaultname.range(of: "新浪") != nil) || (defaultname.range(of: "微博") != nil) {
            cell!.imageView?.image = UIImage(named:"sina.png")
        } else if (defaultname.range(of: "Twitter") != nil) || (defaultname.range(of: "twitter") != nil){
            cell!.imageView?.image = UIImage(named:"twitter.png")
        } else if (defaultname.range(of: "Facebook") != nil) || (defaultname.range(of: "facebook") != nil){
            cell!.imageView?.image = UIImage(named:"facebook.png")
        } else {
            cell!.imageView?.image = UIImage(named:"lock.png")
        }
        cell!.imageView?.layer.cornerRadius = 4
        //leftsilde
        //cell!.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: UIColor.green)
        //    ,MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.yellow)]
        //cell!.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        //rightsilde
        cell!.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.red)
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGray)]
        cell!.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        return cell!
    }

    //required method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.result!.count
        if count == 0 {
            self.emptyView.isHidden = false
        }
        return count
    }
    
    @IBAction func popupDialog(_ sender: Any) {
        //basic assets
        let title = "PM 1.0"
        let message = "你能通过此APP储存你容易忘记的密码，除此之外，它还有其他功能。"
        let image = UIImage(named: "")
        //create dialog
        let popup = PopupDialog(title: title,message: message,image: image)
        PopupDialogDefaultView.appearance().titleFont = UIFont.boldSystemFont(ofSize: 20)
        //buttons 
        let btnZero = DefaultButton(title: "添加密码") {
            self.performSegue(withIdentifier: "addBtn", sender: self)
        }
        let btnOne = DefaultButton(title: "更换头像") {
            self.performSegue(withIdentifier: "infoBtn", sender: self)
        }
        let btnTwo = DefaultButton(title: "问题反馈") {
            self.performSegue(withIdentifier: "feedbackBtn", sender: self)
        }
        let btnThree = DefaultButton(title: "关于我们") {
            self.performSegue(withIdentifier: "aboutusBtn", sender: self)
        }
        let btnFour = CancelButton(title: "退出登录") {
            // 移除 userdefaults
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "userPass")
            self.performSegue(withIdentifier: "exitBtn", sender: self)
        }
        //add btn to dialog
        popup.addButtons([btnZero, btnOne, btnTwo, btnThree, btnFour])
        //present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    //处理选中的单元格事件
    //func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //    self.tableview!.deselectRow(at: indexPath, animated: true)
    //    let items = self.result![indexPath.row]
    //    self.performSegue(withIdentifier: "showDetail", sender: items)
    //}
    
    //给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! detailPasswords
            controller.items = sender as? Passwords
        }
    }
    
    //处理高亮单元格事件  这个更好
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.tableview!.deselectRow(at: indexPath, animated: true)
        let items = self.result![indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: items)
    }
    
}
