//
//  UIImageView+YQAsynchronousImage.m
//  Demo
//
//  Created by maygolf on 16/9/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UIImageView+YQAsynchronousImage.h"

static const char *kYQImageKey  = "imageKey";
static const char *kLoadingViewKey  = "loadingViewKey";

@interface UIImageView (YQAsynchronousImagePrivateProperty)

@property (nonatomic, strong) id<YQImage> yqImage;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation UIImageView (YQAsynchronousImagePrivateProperty)

#pragma mark - getter
- (id<YQImage>)yqImage{
    return objc_getAssociatedObject(self, kYQImageKey);
}

- (UIActivityIndicatorView *)loadingView
{
    UIActivityIndicatorView *loadingView = objc_getAssociatedObject(self, kLoadingViewKey);
    if (loadingView == nil) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return loadingView;
}

#pragma mark - setting
- (void)setYqImage:(id<YQImage>)yqImage{
    objc_setAssociatedObject(self, kYQImageKey, yqImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLoadingView:(UIActivityIndicatorView *)loadingView
{
    objc_setAssociatedObject(self, kLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImageView (YQAsynchronousImage)

#pragma mark - private

- (BOOL)aImage:(id<YQImage>)aImage isEqualToImage:(id<YQImage>)otherImage{
    if ([self.yqImage respondsToSelector:@selector(isEqualToImage:)]) {
        return [aImage isEqualToImage:otherImage];
    }else{
        return [aImage isEqual:otherImage];
    }
}

- (void)setImage:(UIImage *)image abstractImage:(id<YQImage>)abstractImage stopLoading:(BOOL)stop{
    if ([self aImage:self.yqImage isEqualToImage:abstractImage]) {
        self.image = image;
        
        if (stop) {
            [self.loadingView stopAnimating];
        }
    }
}

#pragma mark - public
- (void)setAsynchronousImage:(id<YQImage>)image{
    [self setAsynchronousImage:image
                    placeholer:nil
                   showLoading:NO
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer{
    [self setAsynchronousImage:image
                    placeholer:placeholer
                   showLoading:NO
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show{
    [self setAsynchronousImage:image
                    placeholer:placeholer
                   showLoading:show
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show
                  completion:(YQLoadImageCompletion)completion{
    
    // 若果设置的图片和原图片相等，直接返回
    if (image && [image isEqualToImage:self.yqImage]) {
        return;
    }
    
    // 初始化
    self.yqImage = image;
    [self.loadingView stopAnimating];
    self.image = placeholer;
    
    // 若image为空，直接返回
    if (image == nil) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"image is a nil!" code:-1 userInfo:nil];
            completion(nil, nil, error);
        }
        return;
    }
    
    // 显示loading
    if (show) {
        if (self.loadingView.superview == nil) {
            [self addSubview:self.loadingView];
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.loadingView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.loadingView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1
                                                                        constant:0];
            [self addConstraint:centerX];
            [self addConstraint:centerY];
        }
        [self.loadingView startAnimating];
    }
    
    // 获取缓存图片
    UIImage *cacheImage = nil;
    if ([image respondsToSelector:@selector(cacheImage)]) {
        cacheImage = [image cacheImage];
    }
    if (cacheImage) {
        [self setImage:cacheImage abstractImage:image stopLoading:YES];
        
        if (completion) {
            completion(cacheImage, image, nil);
        }
        return;
    }
    
    // 异步获取图片
    if ([image respondsToSelector:@selector(requestImageCompletion:)]) {
        __weak typeof(*&self) weakSelf = self;
        __weak typeof(*&image) weakImage = image;
        [image requestImageCompletion:^(UIImage *resultImage, NSError *error) {
            if (resultImage) {
                [weakSelf setImage:resultImage abstractImage:image stopLoading:YES];
                if (completion) {
                    completion(resultImage, weakImage, nil);
                }
            }else{
                if (completion) {
                    completion(nil, weakImage, [NSError errorWithDomain:@"fetch image fail!" code:-1 userInfo:nil]);
                }
            }
        }];
        return;
    }
    
    // 完成
    if (completion) {
        completion(nil, image, [NSError errorWithDomain:@"fetch image fail!" code:-1 userInfo:nil]);
    }
}

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height{
    [self setAsynchronousImage:image
                         width:width
                        height:height
                    placeholer:nil
                   showLoading:NO
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer{
    [self setAsynchronousImage:image
                         width:width
                        height:height
                    placeholer:placeholer
                   showLoading:NO
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show{
    [self setAsynchronousImage:image
                         width:width
                        height:height
                    placeholer:placeholer
                   showLoading:show
                    completion:nil];
}

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show
                  completion:(YQLoadImageCompletion)completion{
    id<YQImage> targetImage = image;
    if ([image respondsToSelector:@selector(sizeImageWidth:height:)]) {
        targetImage = [image sizeImageWidth:width height:height];
    }
    [self setAsynchronousImage:targetImage
                    placeholer:placeholer
                   showLoading:show
                    completion:^(UIImage *resultImage, id<YQImage> abstractImage, NSError *error) {
                        if (completion) {
                            completion(resultImage, image, error);
                        }
                    }];
}

@end
