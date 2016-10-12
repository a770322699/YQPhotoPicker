//
//  YQSelectedPhoto.m
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQSelectedPhoto.h"

#import "YQPhotoManager.h"

@interface YQSelectedPhoto ()<NSCopying>

@property (nonatomic, assign) CGSize size;

@end

@implementation YQSelectedPhoto

- (instancetype)initWithAsset:(PHAsset *)asset{
    if (self = [super init]) {
        self.assetIdentity = asset.localIdentifier;
    }
    return self;
}

+ (NSArray<YQSelectedPhoto *> *)photosWithAssets:(NSArray<PHAsset *> *)assets{
    NSMutableArray *resultPhotos = nil;
    for (PHAsset *asset in assets) {
        if (resultPhotos == nil) {
            resultPhotos = [NSMutableArray array];
        }
        [resultPhotos addObject:[[self alloc] initWithAsset:asset]];
    }
    
    return resultPhotos;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone{
    YQSelectedPhoto *photo = [[YQSelectedPhoto alloc] init];
    photo.assetIdentity = self.assetIdentity;
    photo.editImage = self.editImage;
    photo.originalImage = self.originalImage;
    photo.size = self.size;
    
    return photo;
}

#pragma mark - YQImageProtocol
// 返回一个可以获取固定大小图片的抽象图片对象
- (id<YQImage>)sizeImageWidth:(CGFloat)width height:(CGFloat)height{
    YQSelectedPhoto *photo = [self copy];
    photo.size = CGSizeMake(width, height);
    return photo;
}

// 获取缓存图片
- (UIImage *)cacheImage{
    if (self.originalImage) {
        return self.originalImage;
    }
    return nil;
}
// 异步获取图片
- (void)requestImageCompletion:(YQRequestImageCompletion)completion{
    
    void(^requestImageCompletion)(UIImage *) = ^(UIImage *resultImage){
        self.originalImage = resultImage;
        if (completion) {
            completion(resultImage, nil);
        }
    };
    
    PHAsset *asset = [YQPhotoManager photoWithIdentity:self.assetIdentity];
    if (self.size.width && self.size.height) {
        [YQPhotoManager requestImageWithAsset:asset targetSize:self.size completion:requestImageCompletion];
    }else{
        [YQPhotoManager requestImageWithAsset:asset completion:requestImageCompletion];
    }
}

- (BOOL)isEqualToImage:(id<YQImage>)image{
    YQSelectedPhoto*photo = (YQSelectedPhoto *)image;
    return [self.assetIdentity isEqualToString:photo.assetIdentity] && self.size.width == photo.size.width && self.size.height == photo.size.height;
}

#pragma mark - YQSelectEntity
- (BOOL)isEqualToEntity:(id)entity{
    YQSelectedPhoto*photo = (YQSelectedPhoto *)entity;
    return [self.assetIdentity isEqualToString:photo.assetIdentity];
}

@end
