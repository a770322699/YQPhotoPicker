//
//  YQPhotoManager.h
//  Demo
//
//  Created by maygolf on 16/9/5.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, YQPhotoSortStyle) {
    YQPhotoSortStyle_Descending,                // 按日期降序
    YQPhotoSortStyle_Ascending,                 // 按日期升序
};

typedef void(^YQSaveImageToAlbumComplet)(BOOL success, PHAssetCollection *album, PHAsset *image, NSError *error);

@interface YQPhotoManager : NSObject

#pragma mark - 获取相册
// 智能相册
+ (NSArray<PHAssetCollection *> *)smartAlbums;
// 用户相册
+ (NSArray<PHAssetCollection *> *)userAlbums;
// 照片流相册
+ (NSArray<PHAssetCollection *> *)photoStreamAlbums;
// 所有照片的相册
+ (NSArray<PHAssetCollection *> *)allPhotoAlbums;
// 通过相册id获取相册
+ (PHAssetCollection *)assetCollectionFromLocalIdentity:(NSString *)localIdentity;

#pragma mark - 获取照片
/**
 *  获取某个相册中的照片
 *
 *  @param album 相册，若为nil，那么获取所有照片
 *  @param style 照片的排序方式
 *
 *  @return 获取照片的结果
 */
+ (PHFetchResult<PHAsset *> *)photosFromAlbumFetchResult:(PHAssetCollection *)album sortStyle:(YQPhotoSortStyle)style;
// 通过id获取照片
+ (PHAsset *)photoWithIdentity:(NSString *)identity;
// 通过AssetLibrary的url获取照片
+ (PHAsset *)photoWithAssetURL:(NSURL *)url;

#pragma mark - AssetLibrary to Photos
// 从AssetLibrary的url得到loacalIdentity
+ (NSString *)assetIdentityFromAssetURL:(NSURL *)url;


#pragma mark - operation
/**
 *  保存图片到相册
 *
 *  @param image     要保存的图片
 *  @param albumName 保存到的相册名称，若该相册尚不存在，创建一个新的相册
 */
+ (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName complettion:(YQSaveImageToAlbumComplet)completion;

#pragma mark - 获取UIImage
// 同步获取指定大小的图片
+ (UIImage *)imageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;
// 异步获取指定大小的图片
+ (void)requestImageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(void (^)(UIImage *resultImage))completion;
// 异步获取原图
+ (void)requestImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *resultImage))completion;

// 同步获取相册封面图
+ (UIImage *)posterImageWithAssetCollection:(PHAssetCollection *)assetCollection targetSize:(CGSize)targetSize;
// 异步获取指定大小封面图
+ (void)requestPosterImageWithAssetCollection:(PHAssetCollection *)assetCollection
                                   targetSize:(CGSize)targetSize
                                   completion:(void(^)(UIImage *resultImage))completion;
// 异步获取原封面图
+ (void)requestPosterImageWithAssetCollection:(PHAssetCollection *)assetCollection
                                   completion:(void (^)(UIImage *))completion;

@end
