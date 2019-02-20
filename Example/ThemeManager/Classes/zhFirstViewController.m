//
//  zhFirstViewController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhFirstViewController.h"
#import "zhNextViewController.h"

@interface zhFirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array1;
@property (nonatomic, strong) NSMutableArray *array2;

@end

@implementation zhFirstViewController

- (instancetype)init {
    if (self = [super init]) {
        NSArray *arr1 = @[@"604-p00551", @"604-p01490", @"604-p01505", @"ph1449-p02096", @"ph1449-p02101"];
        NSArray *arr2 = @[@"mf700-00014329", @"mf700-00014344", @"mf700-00021233", @"mf700-01036711", @"mf700-02883145"];
        _array1 = [NSMutableArray arrayWithArray:arr1];
        [_array1 addObjectsFromArray:arr1];
        _array2 = [NSMutableArray arrayWithArray:arr2];
        [_array2 addObjectsFromArray:arr2];
    }
    return self;
}

- (void)nextClicked {
    zhNextViewController *vc = [zhNextViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 35);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:21];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button zh_setTitleColorPicker:ThemePickerColorKey(@"color04") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationController.navigationBar zh_themeUpdateCallback:^(UINavigationBar* target) {
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
        textAttrs[NSForegroundColorAttributeName] = ThemePickerColorKey(@"color04").color;
        [target setTitleTextAttributes:textAttrs];
    }];
    
    [self.navigationController.navigationBar zh_setBackgroundColorPicker:ThemePickerColorKey(@"color01") forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    NSMutableDictionary *backTextAttrs = [NSMutableDictionary dictionary];
    backTextAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:20];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateNormal];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateHighlighted];
    backItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = @"ThemeManager";
    
    [self commonInitialization];
}

- (void)commonInitialization {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.y = 64;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.delaysContentTouches = NO;
    _tableView.rowHeight = 140;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _tableView.zh_backgroundColorPicker = ThemePickerColorKey(@"color01");
    self.view = _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 10, self.view.frame.size.width - 20, 125);
        imgView.centerX = self.view.frame.size.width / 2;
        [cell addSubview:imgView];
        [cell zh_setAssociatedValue:imgView withKey:_cmd];
    }
    
    UIImageView *imgView = (UIImageView *)[cell zh_getAssociatedValueForKey:_cmd];
    NSDictionary *imgDict = @{AppThemeLight : [UIImage imageNamed:_array1[indexPath.row]],
                              AppThemeNight : [UIImage imageNamed:_array2[indexPath.row]],
                              AppThemeStyle1 : [UIImage imageNamed:_array2[indexPath.row]],
                              AppThemeStyle2 : [UIImage imageNamed:_array2[indexPath.row]],
                              AppThemeStyle3 : [UIImage imageNamed:_array2[indexPath.row]]};
    imgView.zh_imagePicker = ThemePickerImageSets(imgDict);
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.zh_backgroundColorPicker = ThemePickerColorKey(@"color01");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [zhThemeOperator changeThemeDayOrNight];
}

@end
