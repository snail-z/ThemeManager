//
//  zhProgressView.h
//  zhProgressView
//
//  Created by zhanghao on 2017/6/31.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhProgressView : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) float progress;

@end
