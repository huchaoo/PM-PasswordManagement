//
//  feedback.swift
//  PasswordManagementTools
//
//  Created by 胡超 on 2017/2/12.
//  Copyright © 2017年 admirersuper. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import SDCAlertView

class feedback: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var body: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.body.layer.cornerRadius = 4
        self.body.layer.borderColor = UIColor.darkGray.cgColor
        self.body.text = "反馈的问题有："
    }

    @IBAction func sendBtn(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            //get the text
            let subject = self.subject.text
            let body = self.body.text
            //send email
            let mailcontroller = MFMailComposeViewController()
            mailcontroller.mailComposeDelegate = self
            mailcontroller.setSubject(subject!)
            mailcontroller.setToRecipients(["admirersuper@gmail.com"])
            mailcontroller.setMessageBody(body!, isHTML: false)
            
            present(mailcontroller, animated: true, completion: nil)
        }
        else {
            //alertView Controller
            let alert = AlertController(title: "",message: "", preferredStyle: .alert)
            alert.add(AlertAction(title: "确认",style:.normal))
            alert.title = "本设备不支持邮件发送"
            alert.message = "请输入更换设备"
            alert.present()
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result{
        case .sent:
            print("邮件已发送")
        case .cancelled:
            print("邮件已取消")
        case .saved:
            print("邮件已保存")
        case .failed:
            print("邮件发送失败")
        }
    }
    
    @IBAction func backtomain(_ sender: Any) {
        self.performSegue(withIdentifier: "feedbackTomain", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
