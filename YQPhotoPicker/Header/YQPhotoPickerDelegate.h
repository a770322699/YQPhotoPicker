//
//  YQPhotoPickerDelegate.h
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YQSelectedPhoto.h"

@class YQPhotoPicker;
@protocol YQPhotoPickerDelegate <YQObject>

@optional
// 将要弹出选择视图控制器
- (void)photoPicker:(YQPhotoPicker *)photoPicker willPresentPickController:(UIViewController *)pickController;
// 选择视图控制器弹出完成
- (void)photoPicker:(YQPhotoPicker *)photoPicker didPresentPickController:(UIViewController *)pickController;
// 将要弹出选择视图控制器
- (void)photoPicker:(YQPhotoPicker *)photoPicker willDismissPickController:(UIViewController *)pickController;
// 选择视图控制器弹出完成
- (void)photoPicker:(YQPhotoPicker *)photoPicker didDismissPickController:(UIViewController *)pickController;

// 选择照片完成(单张)
- (void)photoPicker:(YQPhotoPicker *)photoPicker didSelectImage:(YQSelectedPhoto *)selectPhoto;
// 选择照片完成(多张)
- (void)photoPicker:(YQPhotoPicker *)photoPicker didSelectImages:(NSArray<YQSelectedPhoto *> *)selectPhotos;
// 取消选择
- (void)photoPickerCancel:(YQPhotoPicker *)photoPicker;

@end
