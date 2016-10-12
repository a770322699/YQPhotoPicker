//
//  MGAlbumImageView.h
//  maygolf
//
//  Created by maygolf on 15/8/18.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQImageView;
@protocol YQImageViewDelegate <NSObject>

@optional
- (void)didClickImageView:(YQImageView *)imageView;
- (void)didLongTouchImageView:(YQImageView *)imageView;
- (void)didClickSelectIconView:(UIImageView *)iconView imageView:(YQImageView *)imageView;

@end

@interface YQImageView : UIImageView

/**
 *  选中图标
 */
@property (nonatomic, strong) UIImage *selectedIcon;
/**
 *  未选中图标
 */
@property (nonatomic, strong) UIImage *unSeletedIcon;
/**
 *  是否允许选中，默认为NO
 *  当值为NO时，selectedIcon和unSelectedIcon无效
 */
@property (nonatomic, assign) BOOL allowSelected;
/**
 *  是否选中
 */
@property (nonatomic, assign,getter = isSelected) BOOL selected;
/**
 *  是否自动改变选中状态，若为yes，点击后自动切换选中状态，默认为yes
 */
@property (nonatomic, assign) BOOL autoChangeState;

/**
 *  显示的图像的对象，设置该属性后不会自动显示图像，需要设置image属性
 */
@property (nonatomic, strong) id imageObject;

/**
 *  点击事件
 *  imageView:被点击的imageView
 *  imageObject:上面的imgaeObject属性
 */
@property (nonatomic, copy) void(^didClick)(YQImageView *imageView,id imageObject);
@property (nonatomic, assign) id<YQImageViewDelegate>delegate;
@property (nonatomic, copy) void(^didClickSelectIconView)(YQImageView *imageView, UIImageView *iconView, id imageObject);

@end
