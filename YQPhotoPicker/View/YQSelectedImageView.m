//
//  YQSelectedImageView.m
//  Demo
//
//  Created by maygolf on 16/10/11.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIImageView+YQAsynchronousImage.h"

#import "YQSelectedImageView.h"

static CGFloat kImageSpace = 3.0;
static CGFloat kImageMargin = 10.0;
static CGFloat kImageSize   = 60.0;
static CGFloat kCollectionViewMargin = 10.0;
static CGFloat kButtonWidth     = 60.0;

static NSString *kCollectionViewCellReuseIdentifier = @"kCollectionViewCellReuseIdentifier";

@interface YQSelectedImageView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *topLine;

@end

@implementation YQSelectedImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.topLine];
        [self addSubview:self.collectionView];
        [self addSubview:self.button];
        
        NSDictionary *views = @{@"topLine" : self.topLine,
                                @"collectionView" : self.collectionView,
                                @"button" : self.button};
        NSDictionary *metrics = @{@"margin" : @(kCollectionViewMargin),
                                  @"buttonWidth" : @(kButtonWidth),
                                  @"collectionHeight" : @(kImageSize + kImageMargin * 2)};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[topLine]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLine(==1.0)]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[collectionView]-0-[button(>=buttonWidth)]-0-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[collectionView(collectionHeight)]-(margin)-|" options:0 metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    
    return self;
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = kImageSpace;
        layout.sectionInset = UIEdgeInsetsMake(kImageMargin, kImageMargin, kImageMargin, kImageMargin);
        layout.itemSize = CGSizeMake(kImageSize, kImageSize);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.layer.masksToBounds = YES;
        _collectionView.layer.borderColor = [UIColor colorWithRed:180.0 / 255
                                                            green:180.0 / 255
                                                             blue:180.0 / 255
                                                            alpha:1].CGColor;
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.cornerRadius = 3.0;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellReuseIdentifier];
    }
    
    return _collectionView;
}

- (UIButton *)button{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _button;
}

- (UIView *)topLine{
    if(!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.translatesAutoresizingMaskIntoConstraints = NO;
        _topLine.backgroundColor = [UIColor colorWithRed:210.0 / 255
                                                   green:210.0 / 255
                                                    blue:210.0 / 255
                                                   alpha:1];
        
    }
    return _topLine;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfImageInSelectedImageView:)]) {
        return [self.delegate numberOfImageInSelectedImageView:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    const NSInteger imageViewTag = 100;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    }
    
    id<YQImage>image = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedImageView:imageAtIndex:)]) {
        image = [self.delegate selectedImageView:self imageAtIndex:indexPath.item];
    }
    
    [imageView setAsynchronousImage:image width:kImageSize height:kImageSize];
    
    return cell;
}

@end
