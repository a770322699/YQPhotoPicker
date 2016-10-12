//
//  YQEditImageViewController.h
//  maygolf
//
//  Created by maygolf on 15/9/11.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YQEditSelectImageView.h"

@class YQEditImageViewController;

@protocol YQEditImageViewControllerDelegate <NSObject>

// 编辑完成
- (void)editDidFinsh:(YQEditImageViewController *)controller originalImage:(UIImage *)originalImage editImage:(UIImage *)editImage;
// 编辑取消
- (void)editCancel:(YQEditImageViewController *)controller origiinalImage:(UIImage *)originalImage;

@end

@interface YQEditImageViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) YQEditSelectImageViewShapeStyle editStyle;      //
@property (nonatomic, assign) CGFloat ratioW_Y;                 // 宽高比      // 默认为1
@property (nonatomic, assign) CGFloat suitableWidth;            // 最适合的宽度，或者直径
@property (nonatomic, strong) id relationObject;                // 一个关联参数，在编辑完成或编辑取消的代理中可以获取使用

@property (nonatomic, weak) id<YQEditImageViewControllerDelegate>delegate;

@end
