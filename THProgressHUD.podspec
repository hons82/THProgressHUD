Pod::Spec.new do |s|
  s.name         	 = "THProgressHUD"
  s.version      	 = "1.0.3"
  s.summary      	 = "THProgressHUD is a lightweight and easy-to-use HUD for iOS 7/8. (Objective-C)"
  s.homepage     	 = "https://github.com/hons82/THProgressHUD"
  s.license      	 = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       	 = { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       	 = { :git => "https://github.com/hons82/THProgressHUD.git", :tag => "v#{s.version}" }
  s.platform     	 = :ios, '7.0'
  s.requires_arc 	 = true
  s.source_files 	 = 'THProgressHUD/*.{h,m}'
  s.resource_bundles = {'THProgressHUDImages' => ['THProgressHUD/Images.xcassets']}
end