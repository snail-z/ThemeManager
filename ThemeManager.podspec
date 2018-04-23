#
# Be sure to run `pod lib lint ThemeManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ThemeManager'
  s.version          = '1.1.1'
  s.summary          = 'ThemeManager is a lightweight library for application to switching themes.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#   s.description      = <<-DESC
# TODO: Add long description of the pod here.
#                        DESC

  s.homepage         = 'https://github.com/snail-z/ThemeManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'snail-z' => 'haozhang0770@163.com' }
  s.source           = { :git => 'https://github.com/snail-z/ThemeManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ThemeManager/Classes/zhTheme.h'

   # 添加子spec
  s.subspec 'Core' do |ss|
    ss.source_files = 'ThemeManager/Classes/Core/**/*'
    ss.public_header_files = 'ThemeManager/Classes/Core/**/*.h'
  end

  s.subspec 'Components' do |ss|
    ss.source_files = 'ThemeManager/Classes/Components/**/*'
    ss.public_header_files = 'ThemeManager/Classes/Components/**/*.h'
    ss.dependency 'ThemeManager/Core'
  end
end
