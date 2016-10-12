//
//  YQImageCollectionViewCell.m
//  maygolf
//
//  Created by maygolf on 15/8/18.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import "YQImageCollectionViewCell.h"

@implementation YQImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark get and set
- (YQImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[YQImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.translatesAutoresizingMaskIntoConstraints = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageView;
}

@end
