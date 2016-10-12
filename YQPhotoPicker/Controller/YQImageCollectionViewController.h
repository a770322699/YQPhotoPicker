//
//  YQImageCollectionViewController.h
//  Demo
//
//  Created by maygolf on 16/9/22.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#import "YQImage.h"
#import "YQSelectedPhoto.h"

@class YQImageCollectionViewController;
@protocol YQImageCollectionViewControllerDelegate <NSObject>

- (void)imageCollectionViewController:(YQImageCollectionViewController *)controller willBack:(NSArray<YQSelectedPhoto *> *)resultSelectedImages;
- (void)imageCollectionViewController:(YQImageCollectionViewController *)controller confirm:(NSArray<YQSelectedPhoto *> *)resultSelectedImages;
- (void)imageCollectionViewControllerCancel:(YQImageCollectionViewController *)controller;

@end

@interface YQImageCollectionViewController : UIViewController

@property (nonatomic, strong) PHAssetCollection *album;
@property (nonatomic, assign) NSInteger maxSelectNumber;
@property (nonatomic, copy) NSArray<YQSelectedPhoto *> *selectedPhotos;

@property (nonatomic, weak) id<YQImageCollectionViewControllerDelegate> delegate;

@end
