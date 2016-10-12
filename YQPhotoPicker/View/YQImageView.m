//
//  MGAlbumImageView.m
//  maygolf
//
//  Created by maygolf on 15/8/18.
//  Copyright (c) 2015年 maygolf. All rights reserved.
//

#import "YQImageView.h"

#define kSelectIconSize  30           // 选择图标大小

#define kIconSelected   [UIImage imageNamed:@"icon_selected"]
#define kIconUnselected [UIImage imageNamed:@"icon_unselected"]

@interface YQImageView ()

@property (nonatomic, strong) UIImageView *selectIconView;
@property (nonatomic, strong) UIView *selectActionView;

@end

@implementation YQImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectedIcon = kIconSelected;
        self.unSeletedIcon = kIconUnselected;
        self.autoChangeState = YES;
        
        NSDictionary *views = @{@"selectIconView" : self.selectIconView};
        
        [self addSubview:self.selectIconView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[selectIconView(width)]"
                                                 options:0
                                                 metrics:@{@"width" : @(kSelectIconSize)}
                                                   views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectIconView(height)]"
                                                                     options:0
                                                                     metrics:@{@"height" : @(kSelectIconSize)}
                                                                       views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectIconView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.5
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectIconView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:0.5
                                                          constant:0]];
        
        [self addSubview:self.selectActionView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectActionView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:0.5
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectActionView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.5
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectActionView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectActionView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1
                                                          constant:0]];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickGesAction:)];
        [self addGestureRecognizer:tapGes];
        
        // 长按
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouchGesAction:)];
        [self addGestureRecognizer:longGes];
        
        // 更新选择图标视图
        [self updateSelectIconView];
        
    }
    return self;
}


#pragma mark - get and set
- (UIImageView *)selectIconView
{
    if (!_selectIconView) {
        _selectIconView = [[UIImageView alloc] init];
        _selectIconView.backgroundColor = [UIColor clearColor];
        _selectIconView.translatesAutoresizingMaskIntoConstraints = NO;
        _selectIconView.userInteractionEnabled = YES;
    }
    return _selectIconView;
}

- (UIView *)selectActionView{
    if (!_selectActionView) {
        _selectActionView = [[UIView alloc] init];
        _selectActionView.backgroundColor = [UIColor clearColor];
        _selectActionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSelectIconView:)];
        [_selectActionView addGestureRecognizer:tapGes];
    }
    return _selectActionView;
}


- (void)setSelected:(BOOL)selected
{
    self.selectIconView.image = selected == YES ? self.selectedIcon : self.unSeletedIcon;
    _selected = selected;
}

- (void)setSelectedIcon:(UIImage *)selectedIcon
{
    if (self.isSelected) {
        self.selectIconView.image = selectedIcon;
    }
    _selectedIcon = selectedIcon;
}

- (void)setUnSeletedIcon:(UIImage *)unSeletedIcon
{
    if(self.isSelected == NO){
        self.selectIconView.image = unSeletedIcon;
    }
    _unSeletedIcon = unSeletedIcon;
}

- (void)setAllowSelected:(BOOL)allowSelected{
    _allowSelected = allowSelected;
    
    [self updateSelectIconView];
}

- (void)setImage:(UIImage *)image{
    [super setImage:image];
    
    [self updateSelectIconView];
}

#pragma mark - private
- (void)updateSelectIconView{
    if (self.image && self.allowSelected) {
        self.selectIconView.hidden = NO;
        self.selectActionView.hidden = NO;
    }else{
        self.selectIconView.hidden = YES;
        self.selectActionView.hidden = YES;
    }
}

#pragma mark - action
- (void)didClickGesAction:(UITapGestureRecognizer *)sender{
    if (self.didClick && self.image) {
        self.didClick(self,self.imageObject);
    }
    if (self.image && self.delegate && [self.delegate respondsToSelector:@selector(didClickImageView:)]) {
        [self.delegate didClickImageView:self];
    }
}

- (void)longTouchGesAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLongTouchImageView:)]) {
            [self.delegate didLongTouchImageView:self];
        }
    }
}

- (void)didClickSelectIconView:(UITapGestureRecognizer *)sender{
    if (self.selectIconView.hidden == NO && self.autoChangeState == YES) {
        self.selected = !self.isSelected;
    }
    
    if (self.didClickSelectIconView && self.image) {
        self.didClickSelectIconView(self,self.selectIconView,self.imageObject);
    }
    if (self.image && self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectIconView:imageView:)]) {
        [self.delegate didClickSelectIconView:self.selectIconView imageView:self];
    }
}

@end

