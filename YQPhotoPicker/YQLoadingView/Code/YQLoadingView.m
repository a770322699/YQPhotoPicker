//
//  YQLoadingView.m
//  maygolf
//
//  Created by maygolf on 15/7/14.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import "YQLoadingView.h"

const NSTimeInterval delayTime = 1.0;

@interface YQLoadingView ()
{
    UIImageView *_successView;
    UIImageView *_failView;
}

@property (nonatomic, strong) UIImageView *successView;
@property (nonatomic, strong) UIImageView *failView;

@end

@implementation YQLoadingView
@synthesize successView = _successView, failView = _failView;

#pragma mark - get and set
- (UIImageView *)successView
{
    if (!_successView) {
        _successView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loading_success"]];
    }
    return _successView;
}

- (UIImageView *)failView
{
    if (!_failView) {
        _failView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loading_error"]];
    }
    return _failView;
}


#pragma mark - public
- (void)showFail:(NSString *)message
{
    self.customView = self.failView;
    self.mode = YQProgressHUDModeCustomView;
    [self showMessage:message time:0];
}
- (void)showSuccess:(NSString *)message
{
    self.customView = self.successView;
    self.mode = YQProgressHUDModeCustomView;
    [self showMessage:message time:0];
}
- (void)showProgress:(double)progress message:(NSString *)message
{
    self.customView = nil;
    self.mode = YQProgressHUDModeAnnularDeterminate;
    self.progress = progress;
    [self showMessage:message];
    
}

// 在1秒后加载
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading
{
    [self showLoading:message whenLoading:isLoading afterTime:delayTime];
}

// 延时显示loadingView
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading afterTime:(NSTimeInterval)afterTime
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, afterTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (*isLoading == YES) {
            [self showLoading:message];
        }
    });
}

// 在1秒后加载
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading progress:(double)progress
{
    [self showLoading:message whenLoading:isLoading afterTime:delayTime progress:progress];
}

// 延时显示loadingView
- (void)showLoading:(NSString *)message whenLoading:(BOOL *)isLoading afterTime:(NSTimeInterval)afterTime progress:(double)progress
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, afterTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (*isLoading == YES) {
            [self showProgress:progress message:message];
        }
    });
}

- (void)showLoading:(NSString *)message
{
    self.customView = nil;
    self.mode = YQProgressHUDModeIndeterminate;
    [self showMessage:message];
}

- (void)showMessage:(NSString *)message time:(NSTimeInterval)time
{
    [self showMessage:message];
    [self performSelector:@selector(hideAnimaition) withObject:nil afterDelay:time ? time : delayTime];
}

- (void)showMessage:(NSString *)message
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimaition) object:nil];
    
    self.labelText = message;
    
    if (!self.superview) {
        if (self.view) {
            [self.view addSubview:self];
        }else{
            [self.viewController.view addSubview:self];
        }
        [self show:YES];
    }
}

- (void)hideAnimaition
{
    [self hide:YES];
}

@end
