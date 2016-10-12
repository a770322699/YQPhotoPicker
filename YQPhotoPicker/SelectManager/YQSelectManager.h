//
//  YQSelectManager.h
//  Demo
//
//  Created by maygolf on 16/9/22.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YQSelectEntity <NSObject>

@required
// 判断两个对象是否相等
- (BOOL)isEqualToEntity:(id)entity;

@end

@interface YQSelectManager : NSObject

// 新添加的对象数组
@property (nonatomic, readonly) NSMutableArray<id<YQSelectEntity>> *addedEntitys;
// 删除的对象数组
@property (nonatomic, readonly) NSMutableArray<id<YQSelectEntity>> *deletedEntitys;
// 最终选中的对象数组
@property (nonatomic, readonly) NSMutableArray<id<YQSelectEntity>> *resultSelectedEntitys;
// 允许选择的最多数量
@property (nonatomic, assign) NSInteger maxNumber;

- (instancetype)initWithSelectedEntitys:(NSArray<id<YQSelectEntity>> *)selecteds;
+ (instancetype)selectManagerWithSelectedEntitys:(NSArray<id<YQSelectEntity>> *)selecteds;

// entity是否被选中
- (BOOL)isSelectedEntity:(id<YQSelectEntity>)entity;
/**
 *  改变选中一个对象，若该对象没选中，那么选中该对象，否则添加该对象
 *
 *  @param entity 需要改变的对象
 *
 *  @return 返回该对象是否被选中（操作后），被选中为yes，未被选中为no
 */
- (BOOL)changeSelectEntity:(id<YQSelectEntity>)entity;
/**
 *  改变选中批量对象，和changeSelectEntity类似
 *
 *  @param entitys 需要改变的对象数组
 *
 *  @return 返回改变有已选中的对象数组，和- (NSArray<id<YQSelectEntity>> *)resultSelectedEntitys结果一致
 */
- (NSArray<id<YQSelectEntity>> *)changeSelectEntitys:(NSArray<id<YQSelectEntity>> *)entitys;

@end
