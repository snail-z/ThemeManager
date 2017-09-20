//
//  zhSecondViewController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhSecondViewController.h"
#import "zhSwitchButton.h"

@interface zhSecondViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation zhSecondViewController

- (void)switchThemeClicked:(UIButton *)sender {
    if ([ThemeManager isCurrentThemeEqual:ThemeNight]) {
        [ThemeManager updateThemeStyle:ThemeDay];
    } else {
        [ThemeManager updateThemeStyle:ThemeNight];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
    textAttrs[NSForegroundColorAttributeName] = ThemePickerWithKey(@"color04");
    [self.navigationController.navigationBar zh_setTitleTextAttributes:textAttrs];
    
    self.navigationItem.title = @"Day or Night";
    
    self.navigationController.navigationBar.zh_overlayColorPicker = ThemePickerWithKey(@"color01");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 37);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button zh_setImagePicker:ThemePickerWithKey(@"image05") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(switchThemeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self commonInitialization];
}

- (void)commonInitialization {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.delaysContentTouches = NO;
    _tableView.rowHeight = 140;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    _tableView.zh_backgroundColorPicker = ThemePickerWithKey(@"color01");
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.size = CGSizeMake(self.view.width, tableView.rowHeight);
        label.text = @"「Stay hungry. Stay foolish」";
        label.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
        label.zh_textColorPicker = ThemePickerWithKey(@"color06");
        [cell.contentView addSubview:label];
        
        UIView *spLine = [UIView new];
        spLine.size = CGSizeMake(self.view.width, 0.5 / [UIScreen mainScreen].scale);
        spLine.y = tableView.rowHeight - 1;
        spLine.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:spLine];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.zh_backgroundColorPicker = ThemePickerWithKey(@"color01");
}

@end
