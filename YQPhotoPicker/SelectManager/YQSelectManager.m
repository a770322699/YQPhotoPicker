//
//  YQSelectManager.m
//  Demo
//
//  Created by maygolf on 16/9/22.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQSelectManager.h"

@interface YQSelectManager ()

// 最初就已经选中的对象数组
@property (nonatomic, copy) NSArray<id<YQSelectEntity>> *selectedEntitys;
// 新添加的对象数组
@property (nonatomic, strong) NSMutableArray<id<YQSelectEntity>> *addedEntitys;
// 删除的对象数组
@property (nonatomic, strong) NSMutableArray<id<YQSelectEntity>> *deletedEntitys;
// 最终选中的对象数组
@property (nonatomic, strong) NSMutableArray<id<YQSelectEntity>> *resultSelectedEntitys;

@end

@implementation YQSelectManager

- (instancetype)initWithSelectedEntitys:(NSArray<id<YQSelectEntity>> *)selecteds{
    if (self = [super init]) {
        _selectedEntitys = selecteds;
        _resultSelectedEntitys = [NSMutableArray arrayWithArray:selecteds];
        _addedEntitys = [NSMutableArray array];
        _deletedEntitys = [NSMutableArray array];
    }
    return self;
}
+ (instancetype)selectManagerWithSelectedEntitys:(NSArray<id<YQSelectEntity>> *)selecteds{
    return [[self alloc] initWithSelectedEntitys:selecteds];
}

#pragma mark - private
// 一个数组中是否包含某个对象
- (id<YQSelectEntity>)entityConllection:(NSArray<id<YQSelectEntity>> *)entitys isContainEntity:(id<YQSelectEntity>)entity{
    for (id<YQSelectEntity> aEntity in entitys) {
        if ([aEntity isEqualToEntity:entity]) {
            return aEntity;
        }
    }
    return nil;
}

// 添加一个对象到一个数组
- (void)addEntity:(id<YQSelectEntity>)entity toArray:(NSMutableArray<id<YQSelectEntity>> *)array{
    if (![self entityConllection:array isContainEntity:entity]) {
        [array addObject:entity];
    }
}

// 从一个数组中删除一个对象
- (void)removeEntity:(id<YQSelectEntity>)entity fromArray:(NSMutableArray *)array{
    id<YQSelectEntity> containEntity = [self entityConllection:array isContainEntity:entity];
    if (containEntity) {
        [array removeObject:containEntity];
    }
}

#pragma mark - public
// entity是否被选中
- (BOOL)isSelectedEntity:(id<YQSelectEntity>)entity{
    return [self entityConllection:self.resultSelectedEntitys isContainEntity:entity];
}

/**
 *  改变选中一个对象，若该对象没选中，那么选中该对象，否则添加该对象
 *
 *  @param entity 需要改变的对象
 *
 *  @return 返回该对象是否被选中（操作后），被选中为yes，未被选中为no
 */
- (BOOL)changeSelectEntity:(id<YQSelectEntity>)entity{
    // 若果未被选中，且当前选中的个数已经大于或等于最大可选中的数量，直接返回no
    if (self.maxNumber > 0 && ![self isSelectedEntity:entity] && self.resultSelectedEntitys.count >= self.maxNumber) {
        return NO;
    }
    
    // 若果已经添加，那么直接从添加的数组中移除,并返回NO
    BOOL isAdded = [self entityConllection:self.addedEntitys isContainEntity:entity];
    if (isAdded) {
        [self removeEntity:entity fromArray:self.addedEntitys];
        [self removeEntity:entity fromArray:self.resultSelectedEntitys];
        return NO;
    }
    
    // 若果未添加，且已经删除，那么从删除数组中移除，并返回yes
    BOOL isDeleted = [self entityConllection:self.deletedEntitys isContainEntity:entity];
    if (isDeleted) {
        [self removeEntity:entity fromArray:self.deletedEntitys];
        [self addEntity:entity toArray:self.resultSelectedEntitys];
        return YES;
    }
    
    // 如果没有添加，也没有删除，根据最初是否已经被选中处理
    BOOL isContentForInit = [self entityConllection:self.selectedEntitys isContainEntity:entity];
    if (isContentForInit) {// 如果最初已经选中，那么将其加入到删除的数组中，并返回no
        [self addEntity:entity toArray:self.deletedEntitys];
        [self removeEntity:entity fromArray:self.resultSelectedEntitys];
        return NO;
    }else{  // 如果最初未被选中，那么加入添加的数组中，并返回yes
        [self addEntity:entity toArray:self.addedEntitys];
        [self addEntity:entity toArray:self.resultSelectedEntitys];
        return YES;
    }
}
/**
 *  改变选中批量对象，和changeSelectEntity类似
 *
 *  @param entitys 需要改变的对象数组
 *
 *  @return 返回改变有已选中的对象数组，和- (NSArray<id<YQSelectEntity>> *)resultSelectedEntitys结果一致
 */
- (NSArray<id<YQSelectEntity>> *)changeSelectEntitys:(NSArray<id<YQSelectEntity>> *)entitys{
    [entitys enumerateObjectsUsingBlock:^(id<YQSelectEntity>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self changeSelectEntity:obj];
    }];
    
    return [self resultSelectedEntitys];
}

@end
