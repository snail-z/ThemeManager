//
//  UISegmentedControl+zhTheme.h
//  ThemeManager_Example
//
//  Created by zhanghao on 2017/11/20.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (zhTheme)

/// Currently only support NSForegroundColorAttributeName / NSFontAttributeName.
- (void)zh_setTitleTextPickerAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state;

@end
