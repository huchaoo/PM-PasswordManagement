# PM-PasswordManagementTools
An iOS APP using to manage passwords

# 14天 从零开始 完成一个iOS App

> 本人 大二 计算机科学与技术专业专业学生，对iOS开发感兴趣，在寒假花了两个星期的时间，完成了一个iOS App , 一个密码管理工具 ——PM (PasswordsManagementTool)。
>
> 这个App的灵感是因为平时各种网站、APP所需要的账号和密码太多，一般都会记录到iPhone备忘录中，但觉得不方便、不安全，所以就有开发一个密码管理工具的想法。

#### 下面是本文的目录

* CocoaPods 的安装和使用
* Storyboard 进行视图设计
* 利用 Realm 移动数据库进行数据库设计
* 利用 Swift 语言进行代码书写
* App 细节的优化

*****

##  一、CocoaPods 的安装和使用

网上关于CocoaPods的安装和使用教程有很多，根据PM的功能需求，我选择以下第三方库。

```swift
*Alamofire: Swift语言网络处理库
*MGSwipeTable: UITableCell的特效库
*PermissionScope: 应用权限处理库
*PopupDialog: 仿iOS9的弹窗效果库(iOS10取消UIAlertController)
*Realm: 一个移动端数据库，覆盖Android、iOS等移动端
*RealmSwift: Realm数据库的Swift语言版
*SDCAlertView: 仿iOS9的警示框特效库(iOS10取消UIAlertController)
*SideMenu: 侧边栏弹出特效库
*TextFieldEffects: UITextfield特效库
```

podfile文件如下：

```ruby
platform :ios, '10.0'
use_frameworks!

def pods 
   pod 'SideMenu'
   pod 'MGSwipeTableCell'
   pod 'TextFieldEffects'
   pod 'RealmSwift'
   pod 'Alamofire'
   pod 'PopupDialog', '~> 0.5'
   pod 'SDCAlertView', '~> 7.1'
   pod 'PermissionScope'
end
target ’PasswordManagementTools’ do
    pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
```

## 二、Storyboard 进行视图设计

根据App的功能需求分析，主要有如下几个View，在Storyboard分别创建如下View并在工程中新建对应swift文件：

```swift
* MainPage.swift 主视图界面
* SidebarPage.swift 侧边栏视图界面
* AddPassword.swift 添加密码界面
* loginPage.swift 登录界面
* signinPage.swift 注册界面
* uploadImage.swift 上传头像界面
* feedback.swift 问题反馈界面
* aboutus.swift 关于我们界面
* detailPassword.swift 详细密码信息界面
```

视图创建好后，设置各自的Storyboard ID并利用Segue建立跳转关系，在必要的地方利用如下代码进行视图跳转：

```swift
self.performSegue(withIdentifier: String, sender: Any?)  
//其中String为需要跳转到的View的Storyboard ID，sender一般设置为self
```

## 三、利用 Realm 移动数据库进行数据库设计

Realm是一款移动端的数据库，对于我这种新手上手比较容易(本人没接触过CoreData和SQLite),因此在该App采用Realm作为数据库，另外可以到App Store中下载Realm Browser浏览使用Realm创建过的数据库，十分方便。

更多Realm的使用请参照[RealmSwift官网](https://realm.io/docs/swift/latest/)

依据Realm创建数据库的代码如下:

```swift
//
//  utilClass.swift
//
import RealmSwift

//用户数据库 Users
class Users: Object {
    dynamic var u_name = ""
    dynamic var u_phone = ""
    dynamic var u_password = ""
    dynamic var u_pictrue : NSData? = nil
    let Passwords = List<Passwords>()
}

//用户密码数据库 Passwords
class Passwords: Object {
    dynamic var p_number = 0
    dynamic var p_name = ""
    dynamic var p_account = ""
    dynamic var p_password = ""
    dynamic var p_pictrue : NSData? = nil
    dynamic var p_owner = ""
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        let count = realm.objects(Passwords.self).count
        return count + 1
    }
}
```

## 四、利用 Swift 语言进行代码书写

分别在swift文件对应位置进行代码书写，完成对应的功能

该APP中主要有几个地方的代码需要特别注意，贴出代码如下：

```swift
//MainPage.swift实现UITableView显示数据

@IBOutlet weak var tableview: UITableView!

override func viewDidLoad() {
        super.viewDidLoad()
        /*
        code...
        */
        tableview.delegate = self    //所需要的delegate
        tableview.dataSource = self    //数据源的delegate
    }

    //required method :to loading the datasource  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MGSwipeTableCell!
        let items = self.result![indexPath.row]
        cell!.textLabel?.text = "账户名称: " + items.p_name
        cell!.textLabel?.font = UIFont(name: "Helvetica", size: 20.0)
        cell!.detailTextLabel?.text = "账户号: " + items.p_account
        cell!.detailTextLabel?.textColor = UIColor.gray
        cell!.detailTextLabel?.font = UIFont(name: "Helvetica" ,size: 14.0)
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
    
    //给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! detailPasswords
            controller.items = sender as? Passwords
        }
    }
    
    //处理高亮单元格事件  
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.tableview!.deselectRow(at: indexPath, animated: true)
        let items = self.result![indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: items)
    }
```

```swift
// AddPassword.swift loginPage.swift 等具有UITextfield界面
//点击UIViewController空白收回键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
```

```swift
//uploadImage.swift 从系统相册中得到照片并利用alaomfire上传至七牛服务器

@IBOutlet weak var imageView: UIImageView!
//初始化图片选择器控制器
let pick: UIImagePickerController = UIImagePickerController()
    
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
        //利用alaomfire上传
        let token = "填写你自己的token"
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
```

```swift
//feedback.swift 利用系统邮箱发送反馈信息至制定邮箱
import MessageUI

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
```

## 五、App 细节的优化

完成以上工作后在真机上运行发现还有一些细节需要优化。

1.实现自动登录功能 ,在AppDelegate.swift中利用UserDefaults实现，并且能够退出登录

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        autoLogin()
        return true
    }
    
    func autoLogin(){
        //autologin
        let name = UserDefaults.standard.string(forKey: "userName")
        let password = UserDefaults.standard.string(forKey: "userPass")
        if  name != nil && password != nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainpage = Storyboard.instantiateViewController(withIdentifier: "mainpageID")
            self.window?.rootViewController = mainpage
            self.window?.makeKeyAndVisible()
        }
        else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginpage = Storyboard.instantiateViewController(withIdentifier: "loginID")
            self.window?.rootViewController = loginpage
            self.window?.makeKeyAndVisible()
        }
    }

//退出登录
// 移除 userdefaults
UserDefaults.standard.removeObject(forKey: "userName")
UserDefaults.standard.removeObject(forKey: "userPass")
```

2.查看密码时点击👁按钮才能查看明文，否则查看暗文

```swift
        //set rightpic show password
        let seepassView:UIView = UIView(frame: CGRect(x:0,y:0,width:14,height:14))
        let seepassPic:UIImageView = UIImageView(frame: CGRect(x:-2,y:0,width:14,height:14))
        seepassPic.image = UIImage(named:"eyes.png")
        seepassView.addSubview(seepassPic)
        self.password.rightView = seepassView
        self.password.rightViewMode = .always
        self.password.rightView?.isUserInteractionEnabled = true
        let taptosee = UITapGestureRecognizer()
        taptosee.addTarget(self, action: #selector(detailPasswords.tapToSee))
        self.password.rightView?.addGestureRecognizer(taptosee)
        
        //func taptosee
    func tapToSee() {
        if self.password.isSecureTextEntry == true {
            self.password.isSecureTextEntry = false
        }
        else {
            self.password.isSecureTextEntry = true
        }
    }
```



## 总结

作为一个大二学生，能够在两个星期内完成这个App真的十分开心，并且已经在我的iPhone中使用该APP了，希望这个简短的总结能够帮到初学iOS开发的人。

最后贴上GitHub地址：[PM-PasswordManagementTools](https://github.com/admirersuper/PM-PasswordManagementTools)

和作者的Google Mail：[admirersuper@gmail.com](admirersuper@gmail.com)

