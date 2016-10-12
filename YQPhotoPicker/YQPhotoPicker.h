//
//  YQPhotoPicker.h
//  YQPhotoPicker
//
//  Created by maygolf on 16/8/6.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQPhotoPickerDelegate.h"

#import "YQEditImageViewController.h"

@interface YQPhotoPicker : NSObject

@property (nonatomic, weak) id<YQPhotoPickerDelegate> delegate;
/**
 *  用于弹出选择照片控制器的控制器，默认为keyWindow的根视图控制器
 */
@property (nonatomic, weak) UIViewController *baseViewController;
/**
 *  是否可编辑,只对选择单张照片有效
 */
@property (nonatomic, assign) BOOL allowEditing;
/**
 *  编辑风格，可编辑时有效
 */
@property (nonatomic, assign) YQEditSelectImageViewShapeStyle editStyle;
/**
 *  编辑图片宽高比，可编辑时有效
 */
@property (nonatomic, assign) CGFloat ratioW_Y;
/**
 *  编辑最合适的宽度，可编辑时有效
 */
@property (nonatomic, assign) CGFloat suitableWidth;

/**
 *  已经选择的图片数组
 */
@property (nonatomic, copy) NSArray<YQSelectedPhoto *> *selectedImages;

/**
 *  最多可选张数
 */
@property (nonatomic, assign) NSInteger allowMaxNumber;
/**
 *  自定义相册名称，拍摄的照片将会存储在该相册中,若拍摄的照片不用保存，那么此参数设置为nil
 */
@property (nonatomic, strong) NSString *customAlbumName;

// 查看摄像头是否可用
+ (BOOL)isValidForCamera;
// 选择单张照片
- (void)pickSinglePhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType;
- (void)picktSinglePhoto;
- (void)pickSinglePhotoWithActionViewTitle:(NSString *)title message:(NSString *)message;

// 选择多张照片
- (void)pickMultiPhtots;

@end
