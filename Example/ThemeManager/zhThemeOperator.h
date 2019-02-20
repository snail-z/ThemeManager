//
//  zhThemeOperator.h
//  ThemeManager_Example
//
//  Created by zhanghao on 2019/2/19.
//  Copyright © 2019年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 对应配置文件中的key
UIKIT_EXTERN NSString *AppThemeLight;  // DAY
UIKIT_EXTERN NSString *AppThemeNight;  // NIGHT
UIKIT_EXTERN NSString *AppThemeStyle1; // STYLE1
UIKIT_EXTERN NSString *AppThemeStyle2; // STYLE2
UIKIT_EXTERN NSString *AppThemeStyle3; // STYLE3

@interface zhThemeOperator : NSObject

+ (void)themeConfiguration;

+ (void)changeThemeDayOrNight;
+ (void)changeThemeStyleWithKey:(NSString *)styleKey;

@end

NS_ASSUME_NONNULL_END
