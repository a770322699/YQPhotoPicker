//
//  YQAlbumTableViewCell.m
//  Demo
//
//  Created by maygolf on 16/9/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIView+YQProperty.h"

#import "YQAlbumTableViewCell.h"

@interface YQAlbumTableViewCell ()

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation YQAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *textBgView = [[UIView alloc] init];
        textBgView.backgroundColor = [UIColor clearColor];
        textBgView.translatesAutoresizingMaskIntoConstraints = NO;
        textBgView.yq_intrinsicContentSize = CGSizeZero;
        [textBgView addSubview:self.nameLable];
        [textBgView addSubview:self.countLabel];
        NSDictionary *textBgViewConstraintViews = @{@"countLabel" : self.countLabel, @"nameLabel" : self.nameLable};
        NSArray *nameLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[nameLabel]-(<=0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:textBgViewConstraintViews];
        NSArray *countLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[countLabel]-(<=0)-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:textBgViewConstraintViews];
        NSArray *nameCountLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[nameLabel]-0-[countLabel]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:textBgViewConstraintViews];
        [textBgView addConstraints:nameLabelH];
        [textBgView addConstraints:countLabelH];
        [textBgView addConstraints:nameCountLabelV];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.yq_intrinsicContentSize = CGSizeZero;
        [contentView addSubview:self.posterView];
        [contentView addSubview:textBgView];
        NSLayoutConstraint *posterViewCenterY = [NSLayoutConstraint constraintWithItem:self.posterView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:contentView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1
                                                                              constant:0];
        NSLayoutConstraint *posterViewHeight = [NSLayoutConstraint constraintWithItem:self.posterView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:contentView
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1
                                                                             constant:0];
        NSLayoutConstraint *textViewCenterY = [NSLayoutConstraint constraintWithItem:textBgView
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:contentView
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:0];
        NSLayoutConstraint *textViewHeight = [NSLayoutConstraint constraintWithItem:textBgView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                                             toItem:contentView
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:1
                                                                           constant:0];
        NSArray *posterTextViewH =
        [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[posterView(posterViewWidth)]-(space)-[textView]-(<=0)-|"
                                                options:0
                                                metrics:@{@"posterViewWidth" : @(kYQAlbumTableViewCellPosterViewSize), @"space" : @(kYQAlbumTableViewCellImageSpace)}
                                                  views:@{@"posterView" : self.posterView, @"textView" : textBgView}];
        NSArray *posterViewHight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[posterView(height)]"
                                                                           options:0
                                                                           metrics:@{@"height" : @(kYQAlbumTableViewCellPosterViewSize)}
                                                                             views:@{@"posterView" : self.posterView}];
        [contentView addConstraints:@[posterViewCenterY, posterViewHeight, textViewCenterY, textViewHeight]];
        [contentView addConstraints:posterTextViewH];
        [contentView addConstraints:posterViewHight];
        
        [self.contentView addSubview:contentView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(space)-[contentView]-0-|" options:0 metrics:@{@"space" : @(kYQAlbumTableViewCellImageSpace)} views:NSDictionaryOfVariableBindings(contentView)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)posterView{
    if (!_posterView) {
        _posterView = [[UIImageView alloc] init];
        _posterView.backgroundColor = [UIColor clearColor];
        _posterView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _posterView;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.backgroundColor = [UIColor clearColor];
        _nameLable.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _nameLable;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _countLabel;
}

@end
