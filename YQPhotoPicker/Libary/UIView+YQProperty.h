//
//  UIView+YQProperty.h
//  Demo
//
//  Created by maygolf on 16/9/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YQProperty)

// 设置固有大小,当设置为UIViewNoIntrinsicMetric， 或者不设置时，使用系统的固有大小
@property (nonatomic, assign) CGSize yq_intrinsicContentSize;

@end
