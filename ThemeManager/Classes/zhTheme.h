//
//  zhTheme.h
//  ThemeManager
//
//  Created by zhanghao on 2017/5/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#ifndef zhTheme_h
#define zhTheme_h

#import "zhThemeManager.h"
#import "zhThemePicker.h"
#import "NSObject+zhTheme.h"
#import "Components+zhTheme.h"
#import "Supplementary+zhTheme.h"

#define pickerify_property(class, property) _theme_property_cla_ify(class, property)
#define pickerify_method1(class, name1) _theme_method_cla_ify1(class, name1)
#define pickerify_method2(class, name1, name2) _theme_method_cla_ify2(class, name1, name2)

#define _theme_property_cla_ify(CLASSNAME, PROPERTY) interface \
CLASSNAME (zhTheme_ ## PROPERTY ## _Picker) \
@property (nonnull, nonatomic, strong) zhThemePicker *zh_ ## PROPERTY ## Picker; \
@end \
@implementation \
CLASSNAME (zhTheme_ ## PROPERTY ## _Picker) \
- (zhThemePicker *)zh_ ## PROPERTY ## Picker { \
    return zh_getThemePicker(self, @selector(zh_ ## PROPERTY ## Picker)); \
} \
- (void)setZh_ ## PROPERTY ## Picker:(zhThemePicker *)zh_ ## PROPERTY ## Picker { \
    zh_setThemePicker(zh_ ## PROPERTY ## Picker, self, (@#PROPERTY)); \
} \
@end
#define _theme_method_cla_ify1(CLASSNAME, NAME1) interface \
CLASSNAME (zhTheme## NAME1 ## _Picker) \
- (void)zh_ ## NAME1 ## Picker:(zhThemePicker *)picker;\
@end \
@implementation \
CLASSNAME (zhTheme## NAME1 ## _Picker) \
- (void)zh_ ## NAME1 ## Picker:(nonnull zhThemePicker *)picker { \
    NSString *selName = [NSString stringWithFormat:@"%@:", (@#NAME1)]; \
    zh_makeThemePicker1(self, NSSelectorFromString(selName), picker);\
}\
@end
#define _theme_method_cla_ify2(CLASSNAME, NAME1, NAME2) interface \
CLASSNAME (zhTheme_ ## NAME1 ## _ ## NAME2 ## _Picker) \
- (void)zh_ ## NAME1 ## Picker:(nonnull zhThemePicker *)picker1 _ ## NAME2 ## Picker:(nonnull zhThemePicker *)picker2;\
@end \
@implementation \
CLASSNAME (zhTheme_ ## NAME1 ## _ ## NAME2 ## _Picker) \
- (void)zh_ ## NAME1 ## Picker:(zhThemePicker *)picker1 _ ## NAME2 ## Picker:(zhThemePicker *)picker2 { \
    NSString *selName = [NSString stringWithFormat:@"%@:%@:", (@#NAME1), (@#NAME2)]; \
    zh_makeThemePicker2(self, NSSelectorFromString(selName), picker1, picker2);\
}\
@end

#endif /* zhTheme_h */
