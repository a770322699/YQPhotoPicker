//
//  YQPhotoPicker.m
//  YQPhotoPicker
//
//  Created by maygolf on 16/8/6.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSObject+YQDelegate.h"

#import "YQAlbumListViewController.h"
#import "YQImageCollectionViewController.h"

#import "YQPhotoPicker.h"
#import "YQPhotoManager.h"
#import "YQLoadingView.h"

@interface YQPhotoPicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, YQEditImageViewControllerDelegate, YQAlbumListViewControllerDelegate, YQImageCollectionViewControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *singlePickerController;
@property (nonatomic, strong) UINavigationController *multiPickerController;

@end

@implementation YQPhotoPicker

#pragma mark - getter
- (UIViewController *)baseViewController{
    if (!_baseViewController) {
        _baseViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _baseViewController;
}

#pragma mark - privaet
- (void)selectSingleImageDidFinish:(YQSelectedPhoto *)selectedPhoto{
    
    void(^completion)() = ^{
        YQVARSELF
        [self.delegate yq_performSelector:@selector(photoPicker:didSelectImage:) withObjects:&yq_varSelf, &selectedPhoto, nil];
        
        UIViewController *picker = self.singlePickerController;
        [self.delegate yq_performSelector:@selector(photoPicker:willDismissPickController:) withObjects:&yq_varSelf, &picker, nil];
        [self.baseViewController dismissViewControllerAnimated:YES completion:^{
            YQVARSELF
            [self.delegate yq_performSelector:@selector(photoPicker:didDismissPickController:) withObjects:&yq_varSelf, &picker, nil];
        }];
    };

    if (self.customAlbumName && selectedPhoto.originalImage && !selectedPhoto.assetIdentity) {
        static BOOL isLoading = YES;
        
        YQLoadingView *loadingView = [[YQLoadingView alloc] init];
        loadingView.view = self.singlePickerController.view;
        
        [YQPhotoManager saveImage:selectedPhoto.originalImage toAlbum:self.customAlbumName complettion:^(BOOL success, PHAssetCollection *album, PHAsset *image, NSError *error) {
            if (success) {
                selectedPhoto.assetIdentity = image.localIdentifier;
            }
            isLoading = NO;
            [loadingView hideAnimaition];
            
            completion();
        }];
        [loadingView showLoading:nil whenLoading:&isLoading];
    }else{
        completion();
    }
}

- (void)editSelectedImage:(YQSelectedPhoto *)selectedPhoto{
    if (selectedPhoto.originalImage) {
        YQEditImageViewController *editCtrl = [[YQEditImageViewController alloc] init];
        editCtrl.delegate = self;
        editCtrl.image = selectedPhoto.originalImage;
        editCtrl.editStyle = self.editStyle;
        editCtrl.ratioW_Y = self.ratioW_Y;
        editCtrl.suitableWidth = self.suitableWidth;
        editCtrl.relationObject = selectedPhoto;
        
        [self.singlePickerController pushViewController:editCtrl animated:YES];
    }else{
        [self selectSingleImageDidFinish:selectedPhoto];
    }
}

#pragma mark - public
// 查看摄像头是否可用
+ (BOOL)isValidForCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
// 选择单张照片
- (void)pickSinglePhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    // 判断设备是否支持摄像机，如果支持，就使用拍照模式
    // 否则从相片库中选择图片
    if (sourceType == UIImagePickerControllerSourceTypeCamera  && ![YQPhotoPicker isValidForCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *singlePicker = [[UIImagePickerController alloc] init];
    singlePicker.delegate = self;
    singlePicker.sourceType = sourceType;
    singlePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    singlePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.singlePickerController = singlePicker;
    
    YQVARSELF
    [self.delegate yq_performSelector:@selector(photoPicker:willDismissPickController:)
                          withObjects:&yq_varSelf, singlePicker, nil];
    [self.baseViewController presentViewController:singlePicker animated:YES completion:^{
        YQVARSELF
        [self.delegate yq_performSelector:@selector(photoPicker:didPresentPickController:)
                              withObjects:&yq_varSelf, &singlePicker, nil];
    }];
}
- (void)picktSinglePhoto{
    [self pickSinglePhotoWithActionViewTitle:nil message:nil];
}
- (void)pickSinglePhotoWithActionViewTitle:(NSString *)title message:(NSString *)message{
    if ([YQPhotoPicker isValidForCamera]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickSinglePhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickSinglePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self baseViewController];
        [self.baseViewController presentViewController:alertController animated:YES completion:nil];
    }else{
        [self pickSinglePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

// 选择多张照片
- (void)pickMultiPhtots{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您没有打开相册权限，请先在设置中打开相册访问权限！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self.baseViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    YQAlbumListViewController *albumController = [[YQAlbumListViewController alloc] init];
    albumController.delegate = self;
    
    UINavigationController *multiController = [[UINavigationController alloc] initWithRootViewController:albumController];
    self.multiPickerController = multiController;
    
    YQVARSELF
    [self.delegate yq_performSelector:@selector(photoPicker:willDismissPickController:)
                          withObjects:&yq_varSelf, &multiController, nil];
    [self.baseViewController presentViewController:self.multiPickerController animated:YES completion:^{
        YQVARSELF
        [self.delegate yq_performSelector:@selector(photoPicker:didPresentPickController:)
                              withObjects:&yq_varSelf, &multiController, nil];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
// 单张照片选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSString *assetIdentity = [YQPhotoManager assetIdentityFromAssetURL:referenceURL];
    
    YQSelectedPhoto *selectedPhoto = nil;
    if (assetIdentity || originalImage) {
        selectedPhoto = [[YQSelectedPhoto alloc] init];
        selectedPhoto.assetIdentity = assetIdentity;
        selectedPhoto.originalImage = originalImage;
    }
    
    if (selectedPhoto.originalImage && self.allowEditing) {
        [self editSelectedImage:selectedPhoto];
    }else{
        [self selectSingleImageDidFinish:selectedPhoto];
    }
}

// 关闭相机取景器
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    YQVARSELF
    [self.delegate yq_performSelector:@selector(photoPickerCancel:) withObjects:&yq_varSelf, nil];
    [self.delegate yq_performSelector:@selector(photoPicker:willDismissPickController:)
                          withObjects:&yq_varSelf, &picker, nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        YQVARSELF
        [self.delegate yq_performSelector:@selector(photoPicker:didDismissPickController:)
                                  withObjects:&yq_varSelf, &picker, nil];
    }];
}

#pragma mark - YQEditImageViewControllerDelegate
// 编辑完成
- (void)editDidFinsh:(YQEditImageViewController *)controller originalImage:(UIImage *)originalImage editImage:(UIImage *)editImage{
    YQSelectedPhoto *selectedPhoto = controller.relationObject;
    selectedPhoto.editImage = editImage;
    [self selectSingleImageDidFinish:selectedPhoto];
}

// 编辑取消
- (void)editCancel:(YQEditImageViewController *)controller origiinalImage:(UIImage *)originalImage{
    if (self.singlePickerController && self.singlePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        YQVARSELF
        [self.delegate yq_performSelector:@selector(photoPickerCancel:) withObjects:&yq_varSelf, nil];
        
        [self.delegate yq_performSelector:@selector(photoPicker:willDismissPickController:) withObjects:&yq_varSelf, &_singlePickerController, nil];
        [self.singlePickerController dismissViewControllerAnimated:YES completion:^{
            YQVARSELF
            [self.delegate yq_performSelector:@selector(photoPicker:didDismissPickController:) withObjects:&yq_varSelf, &_singlePickerController, nil];
        }];
    }else{
        [controller.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - YQAlbumListViewControllerDelegate
- (void)cancelSelect:(YQAlbumListViewController *)controller{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerCancel:)]) {
        [self.delegate photoPickerCancel:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:willDismissPickController:)]) {
        [self.delegate photoPicker:self willDismissPickController:self.multiPickerController];
    }
    [self.multiPickerController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:didDismissPickController:)]) {
            [self.delegate photoPicker:self didDismissPickController:self.multiPickerController];
        }
    }];
}
- (void)albumListController:(YQAlbumListViewController *)controller didSelected:(PHAssetCollection *)album{
    YQImageCollectionViewController *ctrl = [[YQImageCollectionViewController alloc] init];
    ctrl.delegate = self;
    ctrl.album = album;
    ctrl.selectedPhotos = (NSArray<YQSelectedPhoto *> *)self.selectedImages;
    ctrl.maxSelectNumber = self.allowMaxNumber;
    [controller.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - YQImageCollectionViewControllerDelegate
- (void)imageCollectionViewController:(YQImageCollectionViewController *)controller willBack:(NSArray<YQSelectedPhoto *> *)resultSelectedImages{
    self.selectedImages = resultSelectedImages;
}

- (void)imageCollectionViewController:(YQImageCollectionViewController *)controller confirm:(NSArray<YQSelectedPhoto *> *)resultSelectedImages{
    
    self.selectedImages = resultSelectedImages;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:didSelectImages:)]) {
        [self.delegate photoPicker:self didSelectImages:(NSArray<YQSelectedPhoto *> *)self.selectedImages];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:willDismissPickController:)]) {
        [self.delegate photoPicker:self willDismissPickController:self.multiPickerController];
    }
    
    [self.multiPickerController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:didDismissPickController:)]) {
            [self.delegate photoPicker:self didDismissPickController:self.multiPickerController];
        }
    }];
}

- (void)imageCollectionViewControllerCancel:(YQImageCollectionViewController *)controller{
    [self cancelSelect:nil];
}

@end
