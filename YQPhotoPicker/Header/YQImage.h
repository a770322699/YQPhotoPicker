//
//  YQImage.h
//  Demo
//
//  Created by maygolf on 16/9/19.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YQRequestImageCompletion)(UIImage *image, NSError *error);

@protocol YQImage <NSObject>

@optional
// 返回一个可以获取固定大小图片的抽象图片对象
- (id<YQImage>)sizeImageWidth:(CGFloat)width height:(CGFloat)height;
// 比较是否相等,若不实现，使用NSObject协议的isEqual：；
- (BOOL)isEqualToImage:(id<YQImage>)image;

// 获取缓存图片
- (UIImage *)cacheImage;
// 异步获取图片
- (void)requestImageCompletion:(YQRequestImageCompletion)completion;

@end
