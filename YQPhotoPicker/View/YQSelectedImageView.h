//
//  YQSelectedImageView.h
//  Demo
//
//  Created by maygolf on 16/10/11.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQImage.h"

@class YQSelectedImageView;
@protocol YQSelectedImageViewDelegate <NSObject>

@required
- (NSInteger)numberOfImageInSelectedImageView:(YQSelectedImageView *)view;
- (id<YQImage>)selectedImageView:(YQSelectedImageView *)view imageAtIndex:(NSInteger)index;

@end

@interface YQSelectedImageView : UIView

@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UIButton *button;

@property (nonatomic, weak) id<YQSelectedImageViewDelegate> delegate;

@end
