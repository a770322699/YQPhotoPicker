//
//  NSObject+YQDelegate.m
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSObject+YQDelegate.h"

@implementation NSObject (YQDelegate)

- (void)yq_performSelector:(SEL)aSelector withObjects:(void *)firstArgument, ...{
    
    if ([self respondsToSelector:aSelector]) {
        NSMethodSignature *methodSignature = [self methodSignatureForSelector:aSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = self;
        invocation.selector = aSelector;
        
        va_list argList;
        if (firstArgument) {
            [invocation setArgument:firstArgument atIndex:2];
            
            va_start(argList, firstArgument);
            
            void *temp;
            int index = 3;
            while ((temp = va_arg(argList, void *))) {
                [invocation setArgument:temp atIndex:index];
                index++;
            }
        }
        
        [invocation invoke];
    }
}

@end
