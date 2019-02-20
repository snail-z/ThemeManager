//
//  zhTabBarController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhTabBarController.h"
#import "zhNavigationController.h"

#define kClassVC    @"baseTabBarVCClassString"
#define kTitle      @"title"

@interface zhTabBarController ()

@end

@implementation zhTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置app主题
    [zhThemeOperator themeConfiguration];
    
    // 配置状态栏
    [[UIApplication sharedApplication] zh_themeUpdateCallback:^(UIApplication* target) {
        NSDictionary *d = @{AppThemeLight : @(UIStatusBarStyleDefault),
                            AppThemeNight : @(UIStatusBarStyleLightContent),
                            AppThemeStyle1 : @(UIStatusBarStyleLightContent),
                            AppThemeStyle2 : @(UIStatusBarStyleLightContent),
                            AppThemeStyle3 : @(UIStatusBarStyleLightContent)};
        UIStatusBarStyle status = [[d objectForKey:ThemeManager.style] integerValue];
        [target setStatusBarStyle:status];
    }];
    
    [self commonInitialization];
}

- (void)commonInitialization {
    NSArray *itemsArray = @[@{kClassVC : @"zhFirstViewController",
                              kTitle   : @"Home"},
                            
                            @{kClassVC : @"zhSecondViewController",
                              kTitle   : @"Discover"},
                            
                            @{kClassVC : @"zhThirdViewController",
                              kTitle   : @"Me"} ];

    NSArray<zhThemeImagePicker *> *nolArr = @[
                                         ThemePickerImageKey(@"image01").renderingMode(UIImageRenderingModeAlwaysOriginal),
                                         ThemePickerImageKey(@"image02").renderingMode(UIImageRenderingModeAlwaysOriginal),
                                         ThemePickerImageKey(@"image03").renderingMode(UIImageRenderingModeAlwaysOriginal)];
    
    [itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(obj[kClassVC]) new];
        zhNavigationController *nav = [[zhNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = obj[kTitle];
        
        item.zh_imagePicker = nolArr[idx];
        item.zh_selectedImagePicker = nolArr[idx];
        
        [item zh_themeUpdateCallback:^(id  _Nonnull target) {
            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
            textAttrs[NSForegroundColorAttributeName] = ThemePickerColorKey(@"color02").color;
            textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:12];
            [target setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        }];
        
        self.tabBar.zh_barTintColorPicker = ThemePickerColorKey(@"color05");
        self.tabBar.translucent = NO;
        [self addChildViewController:nav];
    }];
}

@end
