//
//  YQSelectedPhoto.h
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#import "YQSelectManager.h"
#import "YQImage.h"

@interface YQSelectedPhoto : NSObject<YQImage, YQSelectEntity>

@property (nonatomic, strong) UIImage *editImage;           // 编辑完成后的图片，若没有编辑为nil
@property (nonatomic, strong) UIImage *originalImage;       // 原始图片
@property (nonatomic, strong) NSString *assetIdentity;      // 照片在图片库中的id

- (instancetype)initWithAsset:(PHAsset *)asset;
+ (NSArray<YQSelectedPhoto *> *)photosWithAssets:(NSArray<PHAsset *> *)assets;

@end
