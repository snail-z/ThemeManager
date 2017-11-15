//
//  zhTestView.h
//  ThemeManager_Example
//
//  Created by zhanghao on 2017/11/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhTestView : UIView

@property (nonatomic, strong, readonly) UIImageView *aImgView;
@property (nonatomic, strong, readonly) UILabel *aLabel;
@property (nonatomic, strong, readonly) UIButton *aButton;

- (void)setLabelBackgroundColor:(UIColor *)bgColor
               buttonTitleColor:(UIColor *)titleColor
                       andState:(NSInteger)state
                          image:(UIImage *)image
                        imgSize:(CGSize)imgSize;

@end
