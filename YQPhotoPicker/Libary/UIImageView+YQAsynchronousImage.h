//
//  UIImageView+YQAsynchronousImage.h
//  Demo
//
//  Created by maygolf on 16/9/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YQImage.h"

typedef void(^YQLoadImageCompletion)(UIImage *image, id<YQImage>abstractImage, NSError *error);

@interface UIImageView (YQAsynchronousImage)

- (void)setAsynchronousImage:(id<YQImage>)image;

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer;

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show;

- (void)setAsynchronousImage:(id<YQImage>)image
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show
                  completion:(YQLoadImageCompletion)completion;

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height;

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer;

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show;

- (void)setAsynchronousImage:(id<YQImage>)image
                       width:(CGFloat)width
                      height:(CGFloat)height
                  placeholer:(UIImage *)placeholer
                 showLoading:(BOOL)show
                  completion:(YQLoadImageCompletion)completion;

@end
