//
//  SidebarPage.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/1/31.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SidebarPage: UITableViewController{
    
    @IBOutlet weak var userPhoto: UIButton!
    
    var result: Results<Passwords>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view, typically from a nib
        let name = UserDefaults.standard.string(forKey: "userName")
        if  name != nil {
            self.userPhoto.layer.borderColor = UIColor.white.cgColor
            self.userPhoto.layer.borderWidth = 1.5
            self.userPhoto.layer.cornerRadius = 40
            self.userPhoto.layer.masksToBounds = true
            //query the data from database
            let realm = try! Realm()
            result = realm.objects(Passwords.self).filter("p_owner = '\(name!)'")
            //get the UserDefaultValue photo
            let image = realm.objects(Users.self).filter("u_name = '\(name!)'").first?.u_pictrue
            if image != nil {
                self.userPhoto.setImage(UIImage(data: image as! Data), for: .normal)
            }
            else {
                self.userPhoto.setImage(UIImage(named: "default80.png"), for: .normal)
            }
        }
    }
    @IBAction func updateImage(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "updateImage", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
