//
//  YQLoadingView.h
//  maygolf
//
//  Created by maygolf on 15/7/14.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import "YQProgressHUD.h"

@interface YQLoadingView : YQProgressHUD

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView *view;

- (void)showFail:(NSString *)message;
- (void)showSuccess:(NSString *)message;
// 在1秒后加载
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading;
// 在1秒后加载
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading progress:(double)progress;    // 带进度
// 立即加载
- (void)showLoading:(NSString *)message;
- (void)showProgress:(double)progress message:(NSString *)message;      // 带进度
- (void)hideAnimaition;

@end
