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
                                         ThemeImagePickerWithKey(@"image01").renderingMode(UIImageRenderingModeAlwaysOriginal),
                                         ThemeImagePickerWithKey(@"image02").renderingMode(UIImageRenderingModeAlwaysOriginal),
                                         ThemeImagePickerWithKey(@"image03").renderingMode(UIImageRenderingModeAlwaysOriginal)];
    
    [itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(obj[kClassVC]) new];
        zhNavigationController *nav = [[zhNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = obj[kTitle];
        
        item.zh_imagePicker = nolArr[idx];
        item.zh_selectedImagePicker = nolArr[idx];
        
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = ThemeColorPickerWithKey(@"color02");
        textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:12];
        [item zh_setTitleTextPickerAttributes:textAttrs forState:UIControlStateNormal];

        self.tabBar.zh_overlayColorPicker = ThemeColorPickerWithKey(@"color05").animated(YES);
        self.tabBar.translucent = NO;
        [self addChildViewController:nav];
    }];
}

@end
