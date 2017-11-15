//
//  zhNavigationController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhNavigationController.h"

@interface zhNavigationController ()

@end

@implementation zhNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
