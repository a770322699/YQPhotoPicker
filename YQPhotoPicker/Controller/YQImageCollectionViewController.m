//
//  YQImageCollectionViewController.m
//  Demo
//
//  Created by maygolf on 16/9/22.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIImageView+YQAsynchronousImage.h"
#import "YQConstant.h"

#import "YQImageCollectionViewController.h"

#import "YQImageCollectionViewCell.h"
#import "YQSelectedImageView.h"

#import "YQPhotoManager.h"
#import "YQSelectManager.h"

static const CGFloat kYQImageSpace = 3.0;
static const CGFloat kYQImageSectionMargin = 3.0;
static const NSInteger kNumberOfItemOnLine = 4;

@interface YQImageCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, YQImageViewDelegate, YQSelectedImageViewDelegate>

@property (nonatomic, strong) NSArray<YQSelectedPhoto *> *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YQSelectedImageView *selectedView;
@property (nonatomic, strong) NSLayoutConstraint *selectedViewTop;
@property (nonatomic, strong) NSLayoutConstraint *selectedViewBottom;

@property (nonatomic, strong) YQSelectManager *selectManager;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) YQImageView *lastPanView;

@end

@implementation YQImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self building];
    [self updateSelectedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    [self.collectionView reloadData];
}

- (void)willMoveToParentViewController:(nullable UIViewController *)parent{
    [super willMoveToParentViewController:parent];
}

#pragma mark - building
- (void)building{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 滑动选择
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:panGes];
    
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yq_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.title = self.album.localizedTitle;
    
    [self.view addSubview:self.selectedView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[selectedView]-0-|" options:0 metrics:nil views:@{@"selectedView" : self.selectedView}]];
    self.selectedViewTop = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    self.selectedViewBottom = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:self.selectedViewTop];
    
    [self.selectedView setNeedsLayout];
    [self.selectedView layoutIfNeeded];
}

- (void)updateSelectedView{
    
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    
    if (self.selectManager.resultSelectedEntitys.count) {
        [self.view removeConstraint:self.selectedViewTop];
        [self.view addConstraint:self.selectedViewBottom];
        self.collectionView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, self.selectedView.bounds.size.height, contentInset.right);
    }else{
        [self.view removeConstraint:self.selectedViewBottom];
        [self.view addConstraint:self.selectedViewTop];
        self.collectionView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, 0, contentInset.right);
    }
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.selectedView.collectionView reloadData];
    [self.selectedView.button setTitle:[NSString stringWithFormat:@"确定(%ld)", (long)self.selectManager.resultSelectedEntitys.count] forState:UIControlStateNormal];
}

#pragma mark - laodData
- (void)loadData{
    PHFetchResult *photos = [YQPhotoManager photosFromAlbumFetchResult:self.album
                                                             sortStyle:YQPhotoSortStyle_Descending];
    NSArray *assets = [photos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
    self.photos = [YQSelectedPhoto photosWithAssets:assets];
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionViewLayout.minimumLineSpacing = kYQImageSpace;
        collectionViewLayout.minimumInteritemSpacing = kYQImageSpace;
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(kYQImageSectionMargin,
                                                             kYQImageSectionMargin,
                                                             kYQImageSectionMargin,
                                                             kYQImageSectionMargin);
        [self updateItemSize];
        collectionViewLayout.itemSize = [self itemSize];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:collectionViewLayout];
        [_collectionView registerClass:[YQImageCollectionViewCell class]
            forCellWithReuseIdentifier:kYQImageCollectionViewCellIdentity];
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.directionalLockEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (YQSelectManager *)selectManager{
    if (!_selectManager) {
        _selectManager = [YQSelectManager selectManagerWithSelectedEntitys:self.selectedPhotos];
        _selectManager.maxNumber = self.maxSelectNumber;
    }
    return _selectManager;
}

- (YQSelectedImageView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[YQSelectedImageView alloc] init];
        _selectedView.backgroundColor = [UIColor whiteColor];
        _selectedView.delegate = self;
        [_selectedView.button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedView;
}

#pragma mark - private
- (void)updateItemSize{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.itemSize = CGSizeMake((screenSize.width
                               - 2 * kYQImageSectionMargin
                               - (kNumberOfItemOnLine - 1) * kYQImageSpace) / kNumberOfItemOnLine,
                              (screenSize.width
                               - 2 * kYQImageSectionMargin
                               - (kNumberOfItemOnLine - 1) * kYQImageSpace) / kNumberOfItemOnLine);
}

#pragma mark - action
- (void)cancel:(UIBarButtonItem *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCollectionViewControllerCancel:)]) {
        [self.delegate imageCollectionViewControllerCancel:self];
    }
}

- (void)confirm:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCollectionViewController:confirm:)]) {
        [self.delegate imageCollectionViewController:self confirm:(NSArray<YQSelectedPhoto *> *)self.selectManager.resultSelectedEntitys];
    }
}

- (void)back:(UIBarButtonItem *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCollectionViewController:willBack:)]) {
        [self.delegate imageCollectionViewController:self willBack:(NSArray<YQSelectedPhoto *> *)self.selectManager.resultSelectedEntitys];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)panAction:(UIPanGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self.view];
    for (YQImageCollectionViewCell *cell in [self.collectionView visibleCells]) {
        
        if (self.lastPanView != cell.imageView && cell.imageView.imageObject) {
            CGRect convertRect = [self.view convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            if (touchPoint.x <= CGRectGetMaxX(convertRect) && touchPoint.x >= CGRectGetMinX(convertRect) && touchPoint.y >= CGRectGetMinY(convertRect) && touchPoint.y <= CGRectGetMaxY(convertRect)) {
                
                [self didClickSelectIconView:nil imageView:cell.imageView];
                self.lastPanView = cell.imageView;
            }
            
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.lastPanView = nil;
        self.collectionView.scrollEnabled = YES;
    }
}

#pragma mark - UIConllectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YQImageCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kYQImageCollectionViewCellIdentity forIndexPath:indexPath];
    
    if (cell.imageView.allowSelected == NO) {
        cell.imageView.allowSelected = YES;
        cell.imageView.delegate = self;
        cell.imageView.autoChangeState = NO;
    }
    
    YQSelectedPhoto *image = [self.photos objectAtIndex:indexPath.item];
    cell.imageView.imageObject = image;
    cell.imageView.selected = [self.selectManager isSelectedEntity:image];
    [cell.imageView setAsynchronousImage:image width:self.itemSize.width height:self.itemSize.height placeholer:kImgPlaceholder];
    
    return cell;
}

#pragma mark - YQImageViewDelegate
- (void)didClickImageView:(YQImageView *)imageView{
    [self didClickSelectIconView:nil imageView:imageView];
}

- (void)didClickSelectIconView:(UIImageView *)iconView imageView:(YQImageView *)imageView{
    imageView.selected = [self.selectManager changeSelectEntity:imageView.imageObject];
    [self updateSelectedView];
}

#pragma mark - YQSelectedImageViewDelegate
- (NSInteger)numberOfImageInSelectedImageView:(YQSelectedImageView *)view{
    return self.selectManager.resultSelectedEntitys.count;
}

- (id<YQImage>)selectedImageView:(YQSelectedImageView *)view imageAtIndex:(NSInteger)index{
    return (YQSelectedPhoto *)self.selectManager.resultSelectedEntitys[index];
}

@end
