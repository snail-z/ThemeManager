//
//  zhSwitchButton.h
//  ThemeManager
//
//  Created by zhanghao on 2017/9/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhSwitchButton : UIButton

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;
@property(nonatomic, assign, getter=isOn) BOOL on;

@end
