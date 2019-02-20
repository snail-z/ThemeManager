#
# Be sure to run `pod lib lint ThemeManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ThemeManager'
  s.version          = '2.0.0'
  s.summary          = 'ThemeManager is a lightweight library for application to switching themes.'

  s.homepage         = 'https://github.com/snail-z/ThemeManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'snail-z' => 'haozhang0770@163.com' }
  s.source           = { :git => 'https://github.com/snail-z/ThemeManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ThemeManager/Classes/**/*'
  
end
