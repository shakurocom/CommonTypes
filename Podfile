source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'

use_frameworks!

workspace 'CommonTypes'

target 'CommonTypes_Example' do
    project 'CommonTypes_Example.xcodeproj'
    pod 'SwiftLint', '0.57.1'
end

post_install do |installer|

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end

end
