//
//  NSObject+AssociatedObject.h
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)

- (id)zh_getAssociatedValueForKey:(void *)key;

// Association Policy - OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)zh_setAssociatedValue:(id)value withKey:(void *)key;

// Association Policy - OBJC_ASSOCIATION_ASSIGN
- (void)zh_setAssignValue:(id)value withKey:(SEL)key;

// Association Policy - OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)zh_setCopyValue:(id)value withKey:(SEL)key;

- (void)zh_removeAssociatedObjects;

@end
