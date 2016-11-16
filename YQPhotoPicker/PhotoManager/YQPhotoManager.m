//
//  YQPhotoManager.m
//  Demo
//
//  Created by maygolf on 16/9/5.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQPhotoManager.h"

#import "PHAssetCollection+YQImage.h"

@implementation YQPhotoManager

#pragma mark - 获取相册
// 智能相册
+ (NSArray<PHAssetCollection *> *)smartAlbums{
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection
                                                       fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                       subtype:PHAssetCollectionSubtypeAlbumRegular
                                                       options:nil];
    return [self filterEmptyAlbumWithAssetCollections:fetchResult];
}

// 用户相册
+ (NSArray<PHAssetCollection *> *)userAlbums{
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection
                                                       fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                       subtype:PHAssetCollectionSubtypeAlbumRegular
                                                       options:nil];
    return [self filterEmptyAlbumWithAssetCollections:fetchResult];
}

// 照片流相册
+ (NSArray<PHAssetCollection *> *)photoStreamAlbums{
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection
                                                       fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                       subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream
                                                       options:nil];
    return [self filterEmptyAlbumWithAssetCollections:fetchResult];
}

// 所有照片的相册
+ (NSArray<PHAssetCollection *> *)allPhotoAlbums{
    PHFetchResult<PHAsset *> * allPhotos = [self photosFromAlbumFetchResult:nil sortStyle:YQPhotoSortStyle_Ascending];
    PHAssetCollection *album = nil;
    if (allPhotos.count) {
        album = [PHAssetCollection transientAssetCollectionWithAssetFetchResult:allPhotos title:@"所有照片"];
    }
    if (album) {
        return [NSArray arrayWithObject:album];
    }
    
    return nil;
}

// 通过相册id获取相册
+ (PHAssetCollection *)assetCollectionFromLocalIdentity:(NSString *)localIdentity{
    return [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentity] options:nil] firstObject];
}

// 过滤空相册
+ (NSArray <PHAssetCollection *> *)filterEmptyAlbumWithAssetCollections:(PHFetchResult<PHAssetCollection *> *)assetCollections{
    __block NSMutableArray *resultAlbums = nil;
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.assetCount) {
            if (resultAlbums == nil) {
                resultAlbums = [NSMutableArray array];
            }
            [resultAlbums addObject:obj];
        }
    }];
    return resultAlbums;
}

#pragma mark - 获取照片
/**
 *  获取某个相册中的照片
 *
 *  @param album 相册，若为nil，那么获取所有照片
 *  @param style 照片的排序方式
 *
 *  @return 获取照片的结果
 */
+ (PHFetchResult<PHAsset *> *)photosFromAlbumFetchResult:(PHAssetCollection *)album sortStyle:(YQPhotoSortStyle)style{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:style == YQPhotoSortStyle_Ascending]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    
    if (album == nil) {
        return [PHAsset fetchAssetsWithOptions:options];
    }else{
        return [PHAsset fetchAssetsInAssetCollection:album options:options];
    }
}

// 通过id获取照片
+ (PHAsset *)photoWithIdentity:(NSString *)identity{
    return [[PHAsset fetchAssetsWithLocalIdentifiers:@[identity] options:nil] firstObject];
}

// 通过AssetLibrary的url获取照片
+ (PHAsset *)photoWithAssetURL:(NSURL *)url{
    return url ? [[PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil] firstObject] : nil;
}

#pragma mark - AssetLibrary to Photos
// 从AssetLibrary的url得到loacalIdentity
+ (NSString *)assetIdentityFromAssetURL:(NSURL *)url{
    return url ? [self photoWithAssetURL:url].localIdentifier : nil;
}

#pragma mark - operation
/**
 *  保存图片到相册
 *
 *  @param image     要保存的图片
 *  @param albumName 保存到的相册名称，若该相册尚不存在，创建一个新的相册
 */
+ (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName complettion:(YQSaveImageToAlbumComplet)completion{
    if (image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block PHAsset *resultAsset = nil;
            __block PHAssetCollection *resultAssetCollection = nil;
            
            // 在照片库中查找该名称才相册
            NSArray<PHAssetCollection *> *albumFectResult = [self userAlbums];
            for (PHAssetCollection *album in albumFectResult) {
                if ([album.localizedTitle isEqualToString:albumName]) {
                    resultAssetCollection = album;
                    break;
                }
            }
            
            // 创建该名称的相册
            if (resultAssetCollection == nil) {
                
                __block PHObjectPlaceholder *albumPlaceholder = nil;
                __block BOOL isLoading = YES;
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetCollectionChangeRequest *creatAssetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
                    albumPlaceholder = creatAssetCollectionRequest.placeholderForCreatedAssetCollection;
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    resultAssetCollection = [self assetCollectionFromLocalIdentity:albumPlaceholder.localIdentifier];
                    isLoading = NO;
                }];
                
                while (isLoading) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                
            }
            
            // 将照片加入相册中
            __block PHObjectPlaceholder *assetPlaceholder = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *changeAssetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:resultAssetCollection];
                PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                [changeAssetCollectionRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
                
                assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset;
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (completion) {
                    resultAsset = [self photoWithIdentity:assetPlaceholder.localIdentifier];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(success, resultAssetCollection, resultAsset, error);
                    });
                }
            }];
        });
    }else{
        if (completion) {
            completion(NO, nil, nil, [NSError errorWithDomain:@"the image is nil" code:-1 userInfo:nil]);
        }
    }
}

#pragma mark - 获取UIImage
// 同步获取指定大小的图片
+ (UIImage *)imageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize{
    
    __block UIImage *resultImage = nil;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    
    return resultImage;
}

// 异步获取指定大小的图片
+ (void)requestImageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(void (^)(UIImage *resultImage))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result);
        }
    }];
}

// 同步获取原图
+ (UIImage *)imageWithAsset:(PHAsset *)asset{
    __block UIImage *resultImage = nil;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    
    return resultImage;
}

// 异步获取原图
+ (void)requestImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *resultImage))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result);
        }
    }];
}

// 同步获取相册封面图
+ (UIImage *)posterImageWithAssetCollection:(PHAssetCollection *)assetCollection targetSize:(CGSize)targetSize{
    PHAsset *asset = [self photosFromAlbumFetchResult:assetCollection sortStyle:YQPhotoSortStyle_Ascending].firstObject;
    return [self imageWithAsset:asset targetSize:targetSize];
}
// 异步获取指定大小封面图
+ (void)requestPosterImageWithAssetCollection:(PHAssetCollection *)assetCollection
                                   targetSize:(CGSize)targetSize
                                   completion:(void(^)(UIImage *resultImage))completion{
    PHAsset *asset = [self photosFromAlbumFetchResult:assetCollection sortStyle:YQPhotoSortStyle_Ascending].firstObject;
    [self requestImageWithAsset:asset targetSize:targetSize completion:completion];
}
// 异步获取原封面图
+ (void)requestPosterImageWithAssetCollection:(PHAssetCollection *)assetCollection
                                   completion:(void (^)(UIImage *))completion{
    PHAsset *asset = [self photosFromAlbumFetchResult:assetCollection sortStyle:YQPhotoSortStyle_Ascending].firstObject;
    [self requestImageWithAsset:asset completion:completion];
}

@end
