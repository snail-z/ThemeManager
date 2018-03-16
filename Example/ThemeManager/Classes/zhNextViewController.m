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
    self.navigationController.navigationBar.zh_tintColorPicker = ThemeColorPickerWithKey(@"color04");

    [self setupTextView];
    [self setupSegmentedControl];
}

- (void)setupTextView {
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
     [zhThemeColorPicker pickerWithDictionary:dict1],
     [zhThemeColorPicker pickerWithDictionary:dict2],
     [NSNumber numberWithInteger:2],
     [zhThemeImagePicker pickerWithDictionary:dict3],
     [NSValue valueWithCGSize:CGSizeMake(70, 70)]];
}

- (void)setupSegmentedControl {
    NSMutableArray *segmentedArray = [[NSMutableArray alloc] initWithObjects:@"体育", @"娱乐", @"新闻", nil];
    
    UIColor *mainColor = [UIColor colorWithHexString:@"A874E0"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.clipsToBounds = YES;
    
    NSDictionary *dict1 = @{ThemeDay : [UIImage imageWithColor:mainColor],
                            ThemeNight : [UIImage imageWithColor:[UIColor redColor]]};
    
    SEL sel = @selector(setDividerImage:forLeftSegmentState:rightSegmentState:barMetrics:);
    [_segmentedControl zh_addThemePickerForSelector:sel
                                      withArguments:
     ThemeImagePickerWithDictionary(dict1),
     @(UIControlStateNormal),
     @(UIControlStateNormal),
     @(UIBarMetricsDefault)];
    
    NSDictionary *attributesSel = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [_segmentedControl setTitleTextAttributes:attributesSel forState:UIControlStateSelected];
    
    NSDictionary *attributesNor = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [_segmentedControl setTitleTextAttributes:attributesNor forState:UIControlStateNormal];

    NSDictionary *dict2 = @{ThemeDay : [UIColor colorWithHexString:@"C1A9E6"],
                            ThemeNight : [UIColor colorWithHexString:@"FF4747"]};
    _segmentedControl.zh_tintColorPicker = ThemeColorPickerWithDictionary(dict2);
    _segmentedControl.layer.zh_borderColorPicker = ThemeColorPickerWithDictionary(dict2);
    _segmentedControl.layer.borderWidth = 1;
    [self.view addSubview:_segmentedControl];
    
    _segmentedControl.size = CGSizeMake(_testView.width, 40);
    CGFloat centerY = (self.view.height - _testView.bottom) / 2 + _testView.bottom;
    _segmentedControl.centerY = centerY;
    _segmentedControl.centerX = self.view.width / 2;
    _segmentedControl.layer.cornerRadius = _segmentedControl.height / 2;
}

- (void)changeThemeClicked {
    if ([ThemeManager isEqualCurrentStyle:ThemeNight]) {
        [ThemeManager updateThemeStyle:ThemeDay];
    } else {
        [ThemeManager updateThemeStyle:ThemeNight];
    }
}

@end
