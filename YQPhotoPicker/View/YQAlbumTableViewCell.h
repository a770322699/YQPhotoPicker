//
//  YQAlbumTableViewCell.h
//  Demo
//
//  Created by maygolf on 16/9/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kYQAlbumTableViewCellPosterViewSize      =      56.0;
static const CGFloat kYQAlbumTableViewCellImageSpace          =      6.0;
static const CGFloat kYQAlbumTableViewCellHeight =   2 * kYQAlbumTableViewCellImageSpace
                                                   + kYQAlbumTableViewCellPosterViewSize;

static NSString * const kAlbumTableViewCellReuseIdentity = @"kAlbumTableViewCellReuseIdentity";

@interface YQAlbumTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *posterView;
@property (nonatomic, readonly) UILabel *nameLable;
@property (nonatomic, readonly) UILabel *countLabel;

@end
