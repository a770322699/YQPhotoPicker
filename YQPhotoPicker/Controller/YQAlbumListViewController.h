//
//  YQAlbumListViewController.h
//  Demo
//
//  Created by maygolf on 16/9/19.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class YQAlbumListViewController;
@protocol YQAlbumListViewControllerDelegate <NSObject>

- (void)cancelSelect:(YQAlbumListViewController *)controller;
- (void)albumListController:(YQAlbumListViewController *)controller didSelected:(PHAssetCollection *)album;

@end

@interface YQAlbumListViewController : UIViewController

@property (nonatomic, weak) id<YQAlbumListViewControllerDelegate> delegate;

@end
