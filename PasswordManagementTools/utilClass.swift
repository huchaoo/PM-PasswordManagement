//
//  utilClass.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/6.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import RealmSwift


class Users: Object {
    dynamic var u_name = ""
    dynamic var u_phone = ""
    dynamic var u_password = ""
    dynamic var u_pictrue : NSData? = nil
    let Passwords = List<Passwords>()
    
    //override static func primaryKey() -> String?{
    //  return "u_name"
    //}
}

class Passwords: Object {
    dynamic var p_number = 0
    dynamic var p_name = ""
    dynamic var p_account = ""
    dynamic var p_password = ""
    dynamic var p_pictrue : NSData? = nil
    dynamic var p_owner = ""
    //override static func primaryKey() -> String?{
    //  return "p_number"
    //}
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let count = realm.objects(Passwords.self).count
        return count + 1
    }
}

