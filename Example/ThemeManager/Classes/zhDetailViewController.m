//
//  zhDetailViewController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhDetailViewController.h"

@interface zhDetailViewController ()

@end

@implementation zhDetailViewController

- (UIButton *)barItemWithImage:(UIImage *)image action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.frame = CGRectMake(0, 0, 37, 27);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing)]];
    
    UIButton *leftBtn = [self barItemWithImage:[UIImage imageNamed:@"go_back"]
                                        action:@selector(leftItemClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [self barItemWithImage:[UIImage imageNamed:@"switchover"]
                                         action:@selector(switchThemeClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.navigationController.navigationBar zh_themeUpdateCallback:^(UINavigationBar* target) {
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        NSDictionary *fontAttrs = @{AppThemeLight : [UIFont fontWithName:@"Baskerville-BoldItalic" size:25],
                                    AppThemeNight : [UIFont fontWithName:@"ArialHebrew-Bold" size:22],
                                    AppThemeStyle1 : [UIFont fontWithName:@"ArialHebrew-Bold" size:22],
                                    AppThemeStyle2 : [UIFont fontWithName:@"ArialHebrew-Bold" size:20],
                                    AppThemeStyle3 : [UIFont fontWithName:@"ArialHebrew-Bold" size:17]};
        textAttrs[NSFontAttributeName] = ThemePickerFontSets(fontAttrs).font;
        [target setTitleTextAttributes:textAttrs];
    }];
    
    self.navigationItem.title = @"Switch the theme";
    
    [self addSubviews];
}

- (void)addSubviews {
    CGFloat spacing = 60;
    
    UITextField *textField = [UITextField new];
    textField.size = CGSizeMake(300, 50);
    textField.y = 120;
    textField.centerX = self.view.width / 2;
    textField.backgroundColor = [UIColor colorWithHexString:@"272727"];
    textField.textColor = [UIColor whiteColor];
    textField.placeholder = @"I'm a text field.";
    
    textField.zh_placeholderTextColorPicker = ThemePickerColorKey(@"color03");
    
    NSDictionary *fieldFontAttrs = @{AppThemeLight : [UIFont fontWithName:@"Palatino-BoldItalic" size:32],
                                     AppThemeNight : [UIFont fontWithName:@"Palatino-Bold" size:27],
                                     AppThemeStyle1 : [UIFont fontWithName:@"Palatino-BoldItalic" size:32],
                                     AppThemeStyle2 : [UIFont fontWithName:@"Palatino-BoldItalic" size:32],
                                     AppThemeStyle3 : [UIFont fontWithName:@"Palatino-BoldItalic" size:32]};
    textField.zh_fontPicker = ThemePickerFontSets(fieldFontAttrs);
    
    [textField zh_themeUpdateCallback:^(UITextField* target) {
        NSDictionary *KeyboardAttrs = @{AppThemeLight : @(UIKeyboardAppearanceDefault),
                                        AppThemeNight : @(UIKeyboardAppearanceDark),
                                        AppThemeStyle1 : @(UIKeyboardAppearanceDefault),
                                        AppThemeStyle2 : @(UIKeyboardAppearanceDefault),
                                        AppThemeStyle3 : @(UIKeyboardAppearanceDefault)};
        NSInteger state = [KeyboardAttrs[ThemeManager.style] integerValue];
        [target setKeyboardAppearance:state];
        [target reloadInputViews];
    }];
    
    [self.view addSubview:textField];
    
    
    UILabel *label1 = [UILabel new];
    label1.size = CGSizeMake(250, 70);
    label1.centerX = self.view.width / 2;
    label1.y = textField.bottom + spacing;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor colorWithHexString:@"272727"];
    label1.textColor = [UIColor whiteColor];
    label1.text = @"Scorpions";
    NSDictionary *fontAttrs1 = @{AppThemeLight : [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:29],
                                 AppThemeNight : [UIFont fontWithName:@"CourierNewPS-BoldMT" size:33],
                                 AppThemeStyle1 : [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:29],
                                 AppThemeStyle2 : [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:29],
                                 AppThemeStyle3 : [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:29]};
    label1.zh_fontPicker = ThemePickerFontSets(fontAttrs1);
    [self.view addSubview:label1];
    
    
    UILabel *label2 = [UILabel new];
    label2.size = CGSizeMake(250, 70);
    label2.centerX = self.view.width / 2;
    label2.y = label1.bottom + spacing;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor colorWithHexString:@"272727"];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"Metallica";
    NSDictionary *fontAttrs2 = @{AppThemeLight : [UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:35],
                                 AppThemeNight : [UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:25],
                                 AppThemeStyle1 : [UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:35],
                                 AppThemeStyle2 : [UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:35],
                                 AppThemeStyle3 : [UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:35]};
    label2.zh_fontPicker = ThemePickerFontSets(fontAttrs2);
    [self.view addSubview:label2];
    
    
    UILabel *label3 = [UILabel new];
    label3.size = CGSizeMake(350, 70);
    label3.centerX = self.view.width / 2;
    label3.y = label2.bottom + spacing;
    label3.textAlignment = NSTextAlignmentCenter;
    label3.backgroundColor =[UIColor clearColor];
    label3.textColor = [UIColor blackColor];
    label3.text = @"ThemeManager";
    NSDictionary *fontAttrs3 = @{AppThemeLight : [UIFont fontWithName:@"Baskerville-BoldItalic" size:37],
                                 AppThemeNight : [UIFont fontWithName:@"Baskerville-Bold" size:32],
                                 AppThemeStyle1 : [UIFont fontWithName:@"Baskerville-BoldItalic" size:37],
                                 AppThemeStyle2 : [UIFont fontWithName:@"Baskerville-BoldItalic" size:37],
                                 AppThemeStyle3 : [UIFont fontWithName:@"Baskerville-BoldItalic" size:37]};
    label3.zh_fontPicker = ThemePickerFontSets(fontAttrs3);
    [self.view addSubview:label3];
    
    
    UIView *maskView = [UIView new];
    maskView.size = CGSizeMake(self.view.width, self.view.height);
    maskView.bottom  = self.view.bottom;
    maskView.backgroundColor = [UIColor blackColor];
    
    NSDictionary *alphaAttrs = @{AppThemeLight : @0.00,
                                 AppThemeNight : @0.45,
                                 AppThemeStyle1 : @0.00,
                                 AppThemeStyle2 : @0.00,
                                 AppThemeStyle3 : @0.00};
    maskView.zh_alphaPicker = ThemePickerNumberSets(alphaAttrs);
    [self.view addSubview:maskView];
}

#pragma mark - Action

- (void)stopEditing {
    [self.view endEditing:YES];
}

- (void)leftItemClicked {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)switchThemeClicked {
    [zhThemeOperator changeThemeDayOrNight];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)dealloc {
    NSLog(@"dealloc - %@", NSStringFromClass(self.class));
}

@end
