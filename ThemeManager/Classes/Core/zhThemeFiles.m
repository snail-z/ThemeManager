//
//  zhThemeFiles.m
//  ThemeManager
//
//  Created by zhanghao on 2017/5/22.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThemeFiles.h"
#import "zhThemeManager.h"

typedef NS_ENUM(NSInteger, zhThemeFilePlace) {
    zhThemeFilePlaceBundle = 0,
    zhThemeFilePlaceSandbox,
    zhThemeFilePlaceUnknown,
};

NSString *const zhThemeStorageColorFileModelKey = @"zhTheme_storageColorFileKey";
NSString *const zhThemeStorageImageFileModelKey = @"zhTheme_storageImageFileKey";

@interface zhThemeFileModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fixedPath;
@property (nonatomic, assign) zhThemeFilePlace place;
+ (instancetype)modelWithFixed:(NSString *)fixedPath place:(zhThemeFilePlace)place;

@end

@implementation zhThemeFileModel

+ (instancetype)modelWithFixed:(NSString *)fixedPath place:(zhThemeFilePlace)place {
    zhThemeFileModel *model = [zhThemeFileModel new];
    model.fixedPath = fixedPath;
    model.place = place;
    return model;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fixedPath forKey:@"fixedPath"];
    [aCoder encodeObject:@(self.place) forKey:@"place"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.fixedPath = [aDecoder decodeObjectForKey:@"fixedPath"];
        self.place = [[aDecoder decodeObjectForKey:@"place"] integerValue];
    }
    return self;
}

@end

@interface zhThemeFiles ()
@property (nonatomic, strong, nonnull) NSString *colorFile;
@property (nonatomic, strong, nonnull) NSString *imageFile;
@property (nonatomic, strong, nullable) NSString *imageResourcesPath;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id>* colorSources;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id>* imageSources;
@property (nonatomic, strong) id imagesPlace;
@end

@implementation zhThemeFiles

+ (instancetype)defaultManager {
    static zhThemeFiles *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[zhThemeFiles alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:zhThemeStorageColorFileModelKey];
        NSData *data2 = [userDefaults objectForKey:zhThemeStorageImageFileModelKey];
        NSArray *storageKeys = [userDefaults dictionaryRepresentation].allKeys;
        
        if ([storageKeys containsObject:zhThemeStorageColorFileModelKey]) {
            // unarchive the value
            zhThemeFileModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            instance.colorFile = [instance fixedPathFromModel:model];
        } else {
            [instance colorSourcesFromFile:ThemeManager.defaultColorFile];
        }
        
        if ([storageKeys containsObject:zhThemeStorageImageFileModelKey]) {
            zhThemeFileModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
            instance.imageFile = [instance fixedPathFromModel:model];
        } else {
            [instance imageSourcesFromFile:ThemeManager.defaultImageFile];
        }
    });
    return instance;
}

- (NSDictionary *)parseWorkablePath:(NSString *)path {
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
        [dictionary setObject:obj forKey:triKey];
    }];
    return dictionary;
}

- (NSString *)fixedPathFromModel:(zhThemeFileModel *)model {
    if (!model) return nil;
    switch (model.place) {
        case zhThemeFilePlaceBundle:
            return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:model.fixedPath];
        case zhThemeFilePlaceSandbox:
            return [NSHomeDirectory() stringByAppendingPathComponent:model.fixedPath];
        default:
            return model.fixedPath;
    }
}

- (zhThemeFileModel *)fileModelFromPath:(NSString *)fullPath {
    NSMutableString *path = fullPath.mutableCopy;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSRange range = [path rangeOfString:[NSBundle mainBundle].bundlePath];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFileModel modelWithFixed:path place:zhThemeFilePlaceBundle];
        }
        range = [path rangeOfString:NSHomeDirectory()];
        if (range.location != NSNotFound) {
            [path deleteCharactersInRange:range];
            return [zhThemeFileModel modelWithFixed:path place:zhThemeFilePlaceSandbox];
        }
    }
    return [zhThemeFileModel modelWithFixed:path place:zhThemeFilePlaceUnknown];
}

#pragma mark - Setter

- (zhThemeFileModel *)imageSourcesFromFile:(NSString *)file {
    if (!file || [_imageFile isEqualToString:file]) return nil;
    _imageFile = file;
    zhThemeFileModel *model = [self fileModelFromPath:file];
    if (model.place == zhThemeFilePlaceUnknown) {
        NSLog( @"** zhTheme ** Files not exist: %@", file);
    }
    self.imageSources = [self parseWorkablePath:file].mutableCopy;
    return model;
}

- (zhThemeFileModel *)colorSourcesFromFile:(NSString *)file {
    if (!file || [_colorFile isEqualToString:file]) return nil;
    _colorFile = file;
    zhThemeFileModel *model = [self fileModelFromPath:file];
    if (model.place == zhThemeFilePlaceUnknown) {
        NSLog( @"** zhTheme ** Files not exist: %@", file);
    }
    self.colorSources = [self parseWorkablePath:file].mutableCopy;
    return model;
}

- (void)setColorFile:(NSString *)colorFile {
    zhThemeFileModel *model = [self colorSourcesFromFile:colorFile];
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeStorageColorFileModelKey];
    }
}

- (void)setImageFile:(NSString *)imageFile {
    zhThemeFileModel *model = [self imageSourcesFromFile:_imageFile];
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:zhThemeStorageImageFileModelKey];
    }
}

- (void)setImageResourcesPath:(NSString *)imageResourcesPath {
    if (!imageResourcesPath) self.imagesPlace = nil;
    if ([_imageResourcesPath isEqualToString:imageResourcesPath]) return;
    _imageResourcesPath = imageResourcesPath;
    zhThemeFileModel *model = [self fileModelFromPath:imageResourcesPath];
    if (model.place == zhThemeFilePlaceUnknown) {
        NSLog( @"** zhTheme ** Resources path not exist: %@", imageResourcesPath);
    }
    NSString *path = [self fixedPathFromModel:model];
    self.imagesPlace = path;
    if (model.place == zhThemeFilePlaceBundle) {
        self.imagesPlace = [NSBundle bundleWithPath:path];
    }
}

@end
