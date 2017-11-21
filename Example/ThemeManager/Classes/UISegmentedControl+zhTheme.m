//
//  UISegmentedControl+zhTheme.m
//  ThemeManager_Example
//
//  Created by zhanghao on 2017/11/20.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UISegmentedControl+zhTheme.h"
#import <ThemeManager/zhThemeUtilities.h>

@implementation UISegmentedControl (zhTheme)

- (void)zh_setTitleTextPickerAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state {
    zh_setThemeTextAttributesWithState(self, @selector(setTitleTextAttributes:forState:), attributes, state);
}

@end
