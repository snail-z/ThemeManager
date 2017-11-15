//
//  zhNextViewController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhNextViewController.h"
#import "zhTestView.h"

@interface zhNextViewController ()

@property (nonatomic, strong) zhTestView *testView;

@end

@implementation zhNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.zh_tintColorPicker = TMColorWithKey(@"color04");

    _testView = [[zhTestView alloc] init];
    _testView.size = CGSizeMake(270, 300);
    _testView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    _testView.backgroundColor = [UIColor darkGrayColor];
    [_testView.aButton addTarget:self action:@selector(changeThemeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testView];
    
//    UIImage *img = [UIImage imageNamed:@"style3_me"];
//    UIColor *labelColor = [UIColor magentaColor];
//    UIColor *btntieColor = [UIColor orangeColor];
//    [_testView setLabelBackgroundColor:labelColor buttonTitleColor:btntieColor andState:5 image:img imgSize:CGSizeMake(100, 100)];
    
    NSDictionary *dict1 = @{ThemeDay : [UIColor cyanColor], ThemeNight : [UIColor purpleColor]};
    NSDictionary *dict2 = @{ThemeDay : [UIColor cyanColor], ThemeNight : [UIColor purpleColor]};
    NSDictionary *dict3 = @{ThemeDay : [UIImage imageNamed:@"style1_me"], ThemeNight : [UIImage imageNamed:@"style2_me"]};
    
    SEL sel = @selector(setLabelBackgroundColor:buttonTitleColor:andState:image:imgSize:);
    [_testView zh_addThemePickerForSelector:sel
                              withArguments:
     TMColorWithDict(dict1),
     TMColorWithDict(dict2),
     [NSNumber numberWithInteger:2],
     TMImageWithDict(dict3),
     [NSValue valueWithCGSize:CGSizeMake(70, 70)]];
}

- (void)changeThemeClicked {
    if ([ThemeManager isEqualCurrentThemeStyle:ThemeNight]) {
        [ThemeManager updateThemeStyle:ThemeDay];
    } else {
        [ThemeManager updateThemeStyle:ThemeNight];
    }
}

@end
