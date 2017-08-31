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
    
    NSArray<zhThemePicker *> *nolArr = @[
                                         ThemePickerWithKey(@"image01").imageRenderingMode(UIImageRenderingModeAlwaysOriginal).animated(NO),
                                         ThemePickerWithKey(@"image02").imageRenderingMode(UIImageRenderingModeAlwaysOriginal).animated(NO),
                                         ThemePickerWithKey(@"image03").imageRenderingMode(UIImageRenderingModeAlwaysOriginal).animated(NO)];
    
    [itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(obj[kClassVC]) new];
        zhNavigationController *nav = [[zhNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = obj[kTitle];
        
        item.zh_imagePicker = nolArr[idx];
        item.zh_selectedImagePicker = nolArr[idx];
        
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = ThemePickerWithKey(@"color02");
        textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:12];
        [item zh_setTitleTextPickerAttributes:textAttrs forState:UIControlStateNormal];
    
        self.tabBar.zh_overlayColorPicker = ThemePickerWithKey(@"color05");
        self.tabBar.translucent = NO;
        [self addChildViewController:nav];
    }];
}

@end
