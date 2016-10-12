//
//  NSObject+YQDelegate.h
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YQVARSELF   id yq_varSelf = self;

@protocol YQObject <NSObject>

@optional
// 实现了多参数调用
- (void)yq_performSelector:(SEL)aSelector withObjects:(void *)firstArgument, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface NSObject (YQDelegate)<YQObject>

@end
