  <img src="http://oqebi7u13.bkt.clouddn.com/ThemeManager.png" alt="ThemeManager" title="ThemeManager">

[![Language](https://img.shields.io/badge/Language-%20Objective--C%20-orange.svg)](https://travis-ci.org/snail-z/ThemeManager)
[![Version](https://img.shields.io/badge/pod-v1.0.0-brightgreen.svg)](http://cocoapods.org/pods/ThemeManager)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/ThemeManager)
[![Platform](https://img.shields.io/badge/platform-%20iOS7.0+%20-lightgrey.svg)](http://cocoapods.org/pods/ThemeManager)

ThemeManager is a lightweight  library for application to switching themes, inspired by **DKNightVersion**. support more attributes and theme extensions. more easy and convenient to use.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS 7.0 or later
- Requires Automatic Reference Counting (ARC)

## Installation

ThemeManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '7.0'
use_frameworks!

target 'You Project' do
    
	pod "ThemeManager", '~> 1.0.1'
    
end
```

## Preview 

- Switch support images.

  <img src="http://oqebi7u13.bkt.clouddn.com/preview1.gif" width="204px" height="365px">


- Mode during the day and night mode switch of the skin.

  <img src="http://oqebi7u13.bkt.clouddn.com/preview2.gif" width="204px" height="365px">



- A variety of styles to switch.

  <img src="http://oqebi7u13.bkt.clouddn.com/preview3.gif" width="204px" height="365px">

- Support fonts and transparency switches.

  <img src="http://oqebi7u13.bkt.clouddn.com/preview4.gif" width="204px" height="365px">

  ​
## Usage

See demo. please wait...



## Update

- Support iPhone X

- Support iOS 11

- Support custom method theme switch
```objc
// When the external custom methods, you can use it.
- (void)zh_addThemePickerForSelector:(SEL)sel withArguments:(id)arguments, ...;

Note:
The all parameters must be id type. 
if the basic data types needs to be encapsulated into NSNumber; the struct type needs to be encapsulated into NSValue. 
Example：
NSNumber *number = [NSNumber numberWithInteger:2];
NSValue *value = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
[object zh_addThemePickerForSelector:@selector(setInteger:setCGSize:) withArguments:number, value];
```




  ​

## Author

snail-z, haozhang0770@163.com

## License

ThemeManager is available under the MIT license. See the LICENSE file for more info.


