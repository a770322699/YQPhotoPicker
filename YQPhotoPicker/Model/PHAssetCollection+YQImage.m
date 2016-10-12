//
//  PHAssetCollection+YQImage.m
//  Demo
//
//  Created by maygolf on 16/9/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "PHAssetCollection+YQImage.h"
#import "YQPhotoManager.h"

#import "YQPhotoManager.h"

static const char *kYQImagePosterSizeKey = "kYQImagePosterSizeKey";
static const char *kYQImagePosterImageKey = "kYQImagePosterImageKey";
static const char *kYQImageCollectionAssetCountKey = "kYQImageCollectionAssetCountKey";

@interface PHAssetCollection (YQImageProperty)

@property (nonatomic, assign) CGSize posterSize;            // 封面图大小
@property (nonatomic, strong) UIImage *posterImage;         // 封面图片

@end

@implementation PHAssetCollection (YQImageProperty)

#pragma mark - getter
- (CGSize)posterSize{
    return [objc_getAssociatedObject(self, kYQImagePosterSizeKey) CGSizeValue];
}

- (UIImage *)posterImage{
    return objc_getAssociatedObject(self, kYQImagePosterImageKey);
}

#pragma mark - getting
- (void)setPosterSize:(CGSize)posterSize{
    NSValue *sizeValue = [NSValue valueWithCGSize:posterSize];
    objc_setAssociatedObject(self, kYQImagePosterSizeKey, sizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPosterImage:(UIImage *)posterImage{
    objc_setAssociatedObject(self, kYQImagePosterImageKey, posterImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation PHAssetCollection (YQImage)

#pragma mark - getter
- (NSUInteger)assetCount{
    NSUInteger assetCount = 0;
    NSNumber *assetNumber = objc_getAssociatedObject(self, kYQImageCollectionAssetCountKey);
    if (assetNumber) {
        assetCount = [assetNumber unsignedIntegerValue];
    }else{
        PHFetchResult *assets = [YQPhotoManager photosFromAlbumFetchResult:self sortStyle:YQPhotoSortStyle_Ascending];
        assetCount = assets.count;
        self.assetCount = assetCount;
    }
    
    return assetCount;
}

#pragma mark - setting
- (void)setAssetCount:(NSUInteger)assetCount{
    objc_setAssociatedObject(self, kYQImageCollectionAssetCountKey, @(assetCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - YQImageProtocol
// 返回一个可以获取固定大小图片的抽象图片对象
- (id<YQImage>)sizeImageWidth:(CGFloat)width height:(CGFloat)height{
    PHAssetCollection *assetCollection = [self copy];
    assetCollection.posterSize = CGSizeMake(width, height);
    return assetCollection;
}

// 获取缓存图片
- (UIImage *)cacheImage{
    if (self.posterImage) {
        return self.posterImage;
    }
    return nil;
}
// 异步获取图片
- (void)requestImageCompletion:(YQRequestImageCompletion)completion{
    
    void(^requestImageCompletion)(UIImage *) = ^(UIImage *resultImage){
        self.posterImage = resultImage;
        if (completion) {
            completion(resultImage, nil);
        }
    };
    
    if (self.posterSize.width && self.posterSize.height) {
        [YQPhotoManager requestPosterImageWithAssetCollection:self
                                                   targetSize:self.posterSize
                                                   completion:requestImageCompletion];
    }else{
        [YQPhotoManager requestPosterImageWithAssetCollection:self completion:requestImageCompletion];
    }
}

- (BOOL)isEqualToImage:(id<YQImage>)image{
    PHAssetCollection *assetCollection = (PHAssetCollection *)image;
    return [self.localIdentifier isEqualToString:assetCollection.localIdentifier] && self.posterSize.width == assetCollection.posterSize.width && self.posterSize.height == assetCollection.posterSize.height;
}

@end
