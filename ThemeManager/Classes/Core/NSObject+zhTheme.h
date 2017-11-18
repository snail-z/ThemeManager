//
//  NSObject+zhTheme.h
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (zhTheme)

/**
 Note: The all parameters must be id type. if the basic data types needs to be encapsulated into NSNumber; the struct type needs to be encapsulated into NSValue. / 注意: 所有的参数必须为id类型，若是基础数据类型则需要要封装成NSNumber传入；结构体类型则需要封装成NSValue传入
 Example：
 NSNumber *number = [NSNumber numberWithInteger:2];
 NSValue *value = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
 [object zh_addThemePickerForSelector:@selector(setInteger:setCGSize:) withArguments:number, value];
 **/
- (void)zh_addThemePickerForSelector:(SEL)sel withArguments:(id)arguments, ...; // When the external custom methods, you can use it.

@end
