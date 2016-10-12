//
//  PHAssetCollection+YQImage.h
//  Demo
//
//  Created by maygolf on 16/9/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Photos/Photos.h>

#import "YQImage.h"

@interface PHAssetCollection (YQImage)<YQImage>

@property (nonatomic, assign) NSUInteger assetCount;

@end
