//
//  UIView+YQProperty.m
//  Demo
//
//  Created by maygolf on 16/9/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+YQProperty.h"

const char *YQIntrinsticContentSizeKey = "YQIntrinsticContentSizeKey";


// 方法替换
void methodSwizzle(Class theClass, SEL origSEL, SEL overrideSEL){
    Method origMethod = class_getInstanceMethod(theClass, origSEL);
    Method overrideMethod= class_getInstanceMethod(theClass, overrideSEL);
    if (class_addMethod(theClass, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(theClass, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

@implementation UIView (YQProperty)

+ (void)load{
    methodSwizzle(self, @selector(intrinsicContentSize), @selector(yq_intrinsicContentSize));
}

#pragma mark - getter
- (CGSize)yq_intrinsicContentSize{
    CGSize defaultIntrinsicContentSize = [self yq_intrinsicContentSize];
    
    CGSize size = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    NSValue *sizeValue = objc_getAssociatedObject(self, YQIntrinsticContentSizeKey);
    if (sizeValue) {
        size = [sizeValue CGSizeValue];
    }
    
    if (size.width == UIViewNoIntrinsicMetric) {
        size.width = defaultIntrinsicContentSize.width;
    }
    if (size.height == UIViewNoIntrinsicMetric) {
        size.height = defaultIntrinsicContentSize.height;
    }
    
    return size;
}

#pragma mark - setting
- (void)setYq_intrinsicContentSize:(CGSize)yq_intrinsicContentSize{
    objc_setAssociatedObject(self, YQIntrinsticContentSizeKey, [NSValue valueWithCGSize:yq_intrinsicContentSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
