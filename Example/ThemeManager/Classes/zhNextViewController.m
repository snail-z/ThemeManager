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
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation zhNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.zh_tintColorPicker = ThemePickerColorKey(@"color04");

    [self setupTextView];
    [self setupSegmentedControl];
}

- (void)setupTextView {
    _testView = [[zhTestView alloc] init];
    _testView.size = CGSizeMake(270, 300);
    _testView.center = CGPointMake(self.view.width / 2, self.view.height / 3);
    _testView.backgroundColor = [UIColor darkGrayColor];
    [_testView.aButton addTarget:self action:@selector(changeThemeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testView];
    
//    UIImage *img = [UIImage imageNamed:@"style3_me"];
//    UIColor *labelColor = [UIColor magentaColor];
//    UIColor *btntieColor = [UIColor orangeColor];
//    [_testView setLabelBackgroundColor:labelColor buttonTitleColor:btntieColor andState:5 image:img imgSize:CGSizeMake(100, 100)];
    
    [_testView zh_themeUpdateCallback:^(zhTestView* target) {
        NSDictionary *dict1 = @{AppThemeLight : [UIColor cyanColor], AppThemeNight : [UIColor purpleColor]};
        NSDictionary *dict2 = @{AppThemeLight : [UIColor cyanColor], AppThemeNight : [UIColor purpleColor]};
        NSDictionary *dict3 = @{AppThemeLight : [UIImage imageNamed:@"style1_me"], AppThemeNight : [UIImage imageNamed:@"style2_me"]};
        NSString *key = ThemeManager.style;
        [target setLabelBackgroundColor:dict1[key]
                       buttonTitleColor:dict2[key]
                               andState:2 image:dict3[key] imgSize:CGSizeMake(70, 70)];
    }];
}

- (void)setupSegmentedControl {
    NSMutableArray *segmentedArray = [[NSMutableArray alloc] initWithObjects:@"体育", @"娱乐", @"新闻", nil];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.clipsToBounds = YES;
    [_segmentedControl zh_themeUpdateCallback:^(UISegmentedControl* target) {
        UIColor *mainColor = [UIColor colorWithHexString:@"A874E0"];
        NSDictionary *dict1 = @{AppThemeLight : [UIImage imageWithColor:mainColor],
                                AppThemeNight : [UIImage imageWithColor:[UIColor greenColor]]};
        [target setDividerImage:dict1[ThemeManager.style] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }];
    
    NSDictionary *attributesSel = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [_segmentedControl setTitleTextAttributes:attributesSel forState:UIControlStateSelected];
    
    NSDictionary *attributesNor = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [_segmentedControl setTitleTextAttributes:attributesNor forState:UIControlStateNormal];
    
    _segmentedControl.size = CGSizeMake(_testView.width, 35);
    CGFloat centerY = (self.view.height - _testView.bottom) / 3 + _testView.bottom;
    _segmentedControl.centerY = centerY;
    _segmentedControl.centerX = self.view.width / 2;
    _segmentedControl.layer.cornerRadius = _segmentedControl.height / 2;
    
    NSDictionary *dict2 = @{AppThemeLight : [UIColor colorWithHexString:@"C1A9E6"],
                            AppThemeNight : [UIColor colorWithHexString:@"FF4747"]};
    _segmentedControl.zh_tintColorPicker = ThemePickerColorSets(dict2);
    _segmentedControl.layer.zh_borderColorPicker = ThemePickerColorSets(dict2);
    _segmentedControl.layer.borderWidth = 1;
    [self.view addSubview:_segmentedControl];
}

- (void)changeThemeClicked {
    [zhThemeOperator changeThemeDayOrNight];
}

@end
