//
//  YQImageCollectionViewCell.h
//  maygolf
//
//  Created by maygolf on 15/8/18.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQImageView.h"

static  NSString *kYQImageCollectionViewCellIdentity = @"YQImageCollectionViewCellIdentity";

@interface YQImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YQImageView *imageView;

@end
