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

// get picker. properties
id zh_getThemePicker(id instance, const void *key);
// for picker. properties
void zh_setThemePicker(zhThemePicker *picker, id instance, NSString *propertyName);
// for enumerations type.
void zh_makeThemeEnumerations(id instance, SEL aSelector, NSDictionary<NSString *,NSNumber *> *dict);
// for textAttributes.
void zh_makeThemeTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs);
// for textAttributes. with state
void zh_makeThemeStateTextAttributes(id instance, SEL aSelector, NSDictionary<NSString *,id> *attrs, NSInteger state);
// for picker. with state
void zh_makeThemeStatePicker(id instance, SEL aSelector, zhThemePicker *picker, NSInteger state);
// for a picker
void zh_makeThemePicker1(id instance, SEL aSelector, zhThemePicker *picker);
// for two picker.
void zh_makeThemePicker2(NSObject *object, SEL aSelector, zhThemePicker *picker1, zhThemePicker *picker2);

@end
