//
//  zhThemeManager.m
//  <https://github.com/snail-z/ThemeManager>
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeManager.h"

NSString *const zhThemeFileModelStorageColorKey = @"zhTheme_storageColorFileKey";
NSString *const zhThemeFileModelStorageImageKey = @"zhTheme_storageImageFileKey";

@interface zhThemeFilePathModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fixedPath;

typedef NS_ENUM(NSInteger, zhThemeFilePathType) {
    zhThemeFilePathTypeBundle = 0,
    zhThemeFilePathTypeSandbox,
    zhThemeFilePathTypeUnknown,
};
@property (nonatomic, assign) zhThemeFilePathType pathType;

+ (instancetype)modelWithFixed:(NSString *)fixedPath pathType:(zhThemeFilePathType)pathType;

@end

@implementation zhThemeFilePathModel

+ (instancetype)modelWithFixed:(NSString *)fixedPath pathType:(zhThemeFilePathType)pathType {
    zhThemeFilePathModel *model = [zhThemeFilePathModel new];
    model.fixedPath = fixedPath;
    model.pathType = pathType;
    return model;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fixedPath forKey:@"fixedPath"];
    [aCoder encodeObject:@(self.pathType) forKey:@"pathType"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.fixedPath = [aDecoder decodeObjectForKey:@"fixedPath"];
        self.pathType = [[aDecoder decodeObjectForKey:@"pathType"] integerValue];
    }
    return self;
}

@end

@interface zhThemeFileHandle : NSObject

@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSDictionary *>* colorDictionary;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSDictionary *>* imageDictionary;
@property (nonatomic, strong, nullable) id imageSources;

@end

#define ThemeFileHandle [zhThemeFileHandle defaultHandle]

@implementation zhThemeFileHandle

+ (instancetype)defaultHandle {
    static zhThemeFileHandle *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeFileHandle alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *storageKeys = [userDefaults dictionaryRepresentation].allKeys;
        
        if ([storageKeys containsObject:zhThemeFileModelStorageColorKey]) {
            NSData *data = [userDefaults objectForKey:zhThemeFileModelStorageColorKey];
            zhThemeFilePathModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSString *path = [instance convertModelToPath:model];
            [instance setColorFilePath:path];
        } else {
            [instance setColorFilePath:ThemeManager.defaultConfiguration.colorFilePath];
        }

        if ([storageKeys containsObject:zhThemeFileModelStorageImageKey]) {
            NSData *data = [userDefaults objectForKey:zhThemeFileModelStorageImageKey];
            zhThemeFilePathModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSString *path = [instance convertModelToPath:model];
            [instance setImageFilePath:path];
        } else {
            [instance setImageFilePath:ThemeManager.defaultConfiguration.imageFilePath];
        }
    });
    return instance;
}

- (void)setColorFilePath:(NSString *)path {
    if (!path) return;
    zhThemeFilePathModel *model = [self convertPathToModel:path];
    if (model.pathType == zhThemeFilePathTypeUnknown) return;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeFileModelStorageColorKey];
        
    self.colorDictionary = [self parsePath:path].mutableCopy;
}

- (void)setImageFilePath:(NSString *)path {
    if (!path) return;
    zhThemeFilePathModel *model = [self convertPathToModel:path];
    if (model.pathType == zhThemeFilePathTypeUnknown) return;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeFileModelStorageImageKey];
    
    self.imageDictionary = [self parsePath:path].mutableCopy;
}

- (void)setImageSourcesPath:(NSString *)path {
    if (!path) return;
    zhThemeFilePathModel *model = [self convertPathToModel:path];
    if (model.pathType == zhThemeFilePathTypeUnknown) return;
    
    if (model.pathType == zhThemeFilePathTypeBundle) {
        self.imageSources = [NSBundle bundleWithPath:path];
    } else {
        self.imageSources = path;
    }
}

- (NSString *)convertModelToPath:(zhThemeFilePathModel *)model {
    switch (model.pathType) {
        case zhThemeFilePathTypeBundle:
            return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:model.fixedPath];
        case zhThemeFilePathTypeSandbox:
            return [NSHomeDirectory() stringByAppendingPathComponent:model.fixedPath];
        default:
            return model.fixedPath;
    }
}

- (zhThemeFilePathModel *)convertPathToModel:(NSString *)fullPath {
    NSMutableString *path = fullPath.mutableCopy;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSRange range = [path rangeOfString:[NSBundle mainBundle].bundlePath];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFilePathModel modelWithFixed:path pathType:zhThemeFilePathTypeBundle];
        }
        range = [path rangeOfString:NSHomeDirectory()];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFilePathModel modelWithFixed:path pathType:zhThemeFilePathTypeSandbox];
        }
    }
    [ThemeManager debugLog:@"Files not exist: %@", path];
    return [zhThemeFilePathModel modelWithFixed:path pathType:zhThemeFilePathTypeUnknown];
}

- (NSDictionary *)parsePath:(NSString *)path {
    NSDictionary *dict = nil;
    if ([path.pathExtension isEqualToString:@"plist"]) {
        dict = [NSDictionary dictionaryWithContentsOfFile:path];
    } else if ([path.pathExtension isEqualToString:@"json"]) {
        NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        id obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        NSAssert1([obj isKindOfClass:[NSDictionary class]], @"Invalid format of the file content: (%@)", path);
        dict = (NSDictionary *)obj;
    }
    if (dict) return [self trimmingKeyWithDict:dict];
    return nil;
}

- (NSDictionary *)trimmingKeyWithDict:(NSDictionary *)dict {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *triKey = [key stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        [dictionary setValue:obj forKey:triKey];
    }];
    return dictionary;
}

@end

@implementation zhThemeDefaultConfiguration
@end

NSNotificationName const zhThemeUpdateNotification = @"zh.theme.update.notification";
NSString *const zhThemeStyleStorageKey = @"zhThemeStyleStorageKey";

@implementation zhThemeManager

+ (instancetype)sharedManager {
    static zhThemeManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeManager alloc] init];
        instance.themeColorChangeInterval = 0.25;
    });
    return instance;
}

- (BOOL)isEqualCurrentStyle:(zhThemeStyleName)style {
    return [self.currentStyle isEqualToString:style];
}

- (zhThemeStyleName)currentStyle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *style = [userDefaults stringForKey:zhThemeStyleStorageKey];
    if (style) return style;
    return self.defaultConfiguration.style;
}

- (NSDictionary<NSString *,NSDictionary *> *)colorLibraries {
    return ThemeFileHandle.colorDictionary;
}

- (NSDictionary<NSString *,NSDictionary *> *)imageLibraries {
    return ThemeFileHandle.imageDictionary;
}

- (id)pathOfImageSources { // path or bundle
    return ThemeFileHandle.imageSources;
}

- (void)updateThemeStyle:(zhThemeStyleName)style {
    if (!style ||  [self.currentStyle isEqualToString:style]) return;
    [[NSUserDefaults standardUserDefaults] setObject:style forKey:zhThemeStyleStorageKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)updateThemeColorFilePath:(NSString *)path {
    [ThemeFileHandle setColorFilePath:path];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)updateThemeImageFilePath:(NSString *)path {
    [ThemeFileHandle setImageFilePath:path];
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)setThemeImageResourcesPath:(NSString *)path {
    [ThemeFileHandle setImageSourcesPath:path];
}

- (void)reloadTheme {
    [[NSNotificationCenter defaultCenter] postNotificationName:zhThemeUpdateNotification object:nil];
}

- (void)debugLog:(NSString *)description, ... {
    if (!description || !self.debugLogEnabled) return;
    va_list args;
    va_start(args, description);
    NSString *message = [[NSString alloc] initWithFormat:description locale:[NSLocale currentLocale] arguments:args];
    va_end(args);
    NSLog(@"** zhThemeManager ** %@", message);
}

@end
