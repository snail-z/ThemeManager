//
//  zhThemeUtilities.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/11/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "zhThemePicker.h"

// get picker. properties
id zh_getThemePicker(id instance, const void *key);
// for obj properties.
void zh_setThemePicker(zhThemePicker *picker, id instance, NSString *propertyName);
// for enumerations type. exp: keyboardAppearance / statusBarStyle
void zh_setThemeEnumerations(id instance, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict);
// for textAttributes.
void zh_setThemeTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs);
// for textAttributes. with state
void zh_setThemeTextAttributesWithState(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs, NSInteger state);
// for picker. with state
void zh_setThemePickerWithState(id instance, SEL aSelector, zhThemePicker *picker, NSInteger state);
// get current theme style value
id zh_getThemePickerValue(zhThemePicker *picker);
// image by color
UIImage* zh_themeImageFromColor(UIColor *color);
