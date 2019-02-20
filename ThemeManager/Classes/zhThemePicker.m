//
//  zhThemePicker.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemePicker.h"

@interface zhThemePicker ()

@property (nonatomic, strong, readonly) NSString *pKey;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *pSets;

@end

@implementation zhThemePicker

- (instancetype)initWithKey:(NSString *)key dict:(NSDictionary *)dict {
    if (self = [super init]) {
        _pKey = key;
        _pSets = dict;
    }
    return self;
}

+ (instancetype)pickerWithKey:(NSString *)pKey {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end

@implementation zhThemeColorPicker

+ (instancetype)pickerWithKey:(NSString *)pKey {
    return [[self alloc] initWithKey:pKey dict:nil];
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (zhThemeColorPicker *(^)(BOOL))animated {
    return ^id(BOOL isAnimated) {
        self->_isAnimated = isAnimated;
        return self;
    };
}

- (UIColor *)color {
    if (self.pSets) {
        id value = [self.pSets objectForKey:ThemeManager.style];
        if (!value || ![value isKindOfClass:[UIColor class]]) return nil;
        return (UIColor *)value;
    }

    return [ThemeManager cacheColorForKey:self.pKey];
}

@end

@implementation zhThemeImagePicker

- (instancetype)initWithKey:(NSString *)key dict:(NSDictionary *)dict {
    _imageRenderingMode = -1;
    _imageCacheEnabled = NO;
    return [super initWithKey:key dict:dict];
}

+ (instancetype)pickerWithKey:(NSString *)pKey {
    return [[self alloc] initWithKey:pKey dict:nil];
}

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (zhThemeImagePicker * _Nonnull (^)(BOOL))cacheEnabled {
    return ^id(BOOL imageCacheEnabled) {
        self->_imageCacheEnabled = imageCacheEnabled;
        return self;
    };
}

- (zhThemeImagePicker * _Nonnull (^)(UIImageRenderingMode))renderingMode {
    return ^id(UIImageRenderingMode imageRenderingMode) {
        self->_imageRenderingMode = imageRenderingMode;
        return self;
    };
}

- (zhThemeImagePicker * _Nonnull (^)(UIEdgeInsets))resizableCapInsets {
    return ^id(UIEdgeInsets imageCapInsets) {
        self->_imageCapInsets = imageCapInsets;
        return self;
    };
}

- (UIImage *)image {
    if (self.pSets) {
        id value = [self.pSets objectForKey:ThemeManager.style];
        if ([value isKindOfClass:[UIImage class]]) {
            return (UIImage *)value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [UIImage imageNamed:(NSString *)value];
        } else return nil;
    }
    
    UIImage *image = nil;
    if (self.imageCacheEnabled) {
        image = [ThemeManager cacheImageForKey:self.pKey];
    } else {
        image = [ThemeManager imageForKey:self.pKey];
    }
    
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self->_imageCapInsets)) {
        image = [image resizableImageWithCapInsets:self->_imageCapInsets];
    }
    if (self->_imageRenderingMode >= 0) {
        image = [image imageWithRenderingMode:self->_imageRenderingMode];
    }
    return image;
}

@end

@implementation zhThemeFontPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (UIFont *)font {
    if (self.pSets) {
        id value = [self.pSets objectForKey:ThemeManager.style];
        if (!value || ![value isKindOfClass:[UIFont class]]) return nil;
        return (UIFont *)value;
    }
    return nil;
}

@end

@implementation zhThemeTextPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (NSString *)text {
    if (self.pSets) {
        id value = [self.pSets objectForKey:ThemeManager.style];
        if (!value || ![value isKindOfClass:[NSString class]]) return nil;
        return (NSString *)value;
    }
    return nil;
}

@end

@implementation zhThemeNumberPicker

+ (instancetype)pickerWithDictionary:(NSDictionary *)pDict {
    return [[self alloc] initWithKey:nil dict:pDict];
}

- (NSNumber *)number {
    if (self.pSets) {
        id value = [self.pSets objectForKey:ThemeManager.style];
        if (!value || ![value isKindOfClass:[NSNumber class]]) return nil;
        return (NSNumber *)value;
    }
    return nil;
}

@end
