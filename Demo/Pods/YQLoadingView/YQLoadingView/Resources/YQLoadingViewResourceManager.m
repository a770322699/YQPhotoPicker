//
//  YQLoadingViewResourceManager.m
//  Demo
//
//  Created by maygolf on 16/11/16.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQLoadingViewResourceManager.h"

static NSString * const kBundleName = @"YQLoadingView.bundle";
static NSString * const kImageDirName = @"images";

@implementation YQLoadingViewResourceManager

#pragma mark - private
+ (UIImage *)imageWithName:(NSString *)imageName{
    NSString *resultImageName = [NSString stringWithFormat:@"%@/%@/%@", kBundleName, kImageDirName, imageName];
    return [UIImage imageNamed:resultImageName];
}

#pragma mark - public
+ (UIImage *)successImage{
    return [self imageWithName:@"success"];
}

+ (UIImage *)errorImage{
    return [self imageWithName:@"fail"];
}

@end
