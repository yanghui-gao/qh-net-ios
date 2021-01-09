#
# Be sure to run `pod lib lint qh-net-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'qh-net-ios'
  s.version          = '0.1.0'
  s.summary          = 'A short description of qh-net-ios.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/974929538@qq.com/qh-net-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '974929538@qq.com' => 'insistgyh@foxmail.com' }
  s.source           = { :git => 'https://github.com/974929538@qq.com/qh-net-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'qh-net-ios/Classes/**/*'
  
  # s.resource_bundles = {
  #   'qh-net-ios' => ['qh-net-ios/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'SwiftyJSON', '4.3.0'
  s.dependency 'Moya/RxSwift', '14.0.0'
  s.dependency 'MQTTClient', '0.15.3'
end
