//
//  zhViewController.m
//  ThemeManager
//
//  Created by snail-z on 08/31/2017.
//  Copyright (c) 2017 snail-z. All rights reserved.
//

#import "zhViewController.h"
#import <ThemeManager/zhTheme.h>

@interface zhViewController ()

@end

@implementation zhViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton new];
//    btn.yt_themePicker = ThemePickerWithKey(@"").uiColor(@"df").uiImage(@"");
//    ThemePicker.uiColorKey(@"d");
    [self.view addSubview:btn];
    
    [zhThemePicker pickerWithKey:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
