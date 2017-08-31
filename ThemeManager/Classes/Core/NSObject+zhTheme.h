//
//  NSObject+zhTheme.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zhThemeManager.h"
#import "zhThemePicker.h"

@interface NSObject (zhTheme)
// theme listener
NSMutableDictionary<NSString *,id> * addListener(NSObject *object, const void *key, SEL aSelector);
// get picker
id getThemePicker(NSObject *object, const void *key);
// for picker. with properties
void setThemePicker(zhThemePicker *picker, NSObject *object, NSString *propertyName);
// for CA picker. properties
void setThemeCGPicker(zhThemePicker *picker, NSObject *object, NSString *propertyName);
// for picker. with aSelector and state
void makeThemeStatePicker(zhThemePicker *picker, NSObject *object, SEL aSelector, NSInteger state);
// for enum type.
void makeThemeEnumDictionary(NSObject *object, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict);
// for textAttributes.
void makeThemeAttributes(NSObject *object, SEL aSelector, NSDictionary<NSString *,id> *dict);
// for textAttributes. with state
void makeThemeStateAttributes(NSObject *object, SEL aSelector, NSDictionary<NSString *,id> *dict, NSInteger state);
// for picker. with custom selector1
void deployThemePicker1(NSObject *object, SEL aSelector, zhThemePicker *picker);
// for picker. with custom selector2
void deployThemePicker2(NSObject *object, SEL aSelector, zhThemePicker *picker1, zhThemePicker *picker2);
@end
