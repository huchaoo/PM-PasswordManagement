platform :ios, '10.0'
use_frameworks!
def pods 
   pod ‘SideMenu’
   pod ‘MGSwipeTableCell’
   pod ‘TextFieldEffects’
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
