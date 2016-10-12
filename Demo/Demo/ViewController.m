//
//  ViewController.m
//  Demo
//
//  Created by maygolf on 16/9/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSObject+YQDelegate.h"
#import "UIImageView+YQAsynchronousImage.h"

#import "ViewController.h"

#import "YQPhotoPicker.h"

static NSString *kCollectionViewCellReuseIdentifier = @"kCollectionViewCellReuseIdentifier";
static const CGFloat kYQImageSpace = 3.0;
static const CGFloat kYQImageSectionMargin = 3.0;
static const NSInteger kNumberOfItemOnLine = 4;

@interface ViewController ()<YQPhotoPickerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *singleImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) YQPhotoPicker *picker;
@property (nonatomic, strong) NSArray<YQSelectedPhoto *> *selectedPhotos;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self building];
    [self updateInterFace];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - building
- (void)building{
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.minimumLineSpacing = kYQImageSpace;
    collectionViewLayout.minimumInteritemSpacing = kYQImageSpace;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(kYQImageSectionMargin,
                                                         kYQImageSectionMargin,
                                                         kYQImageSectionMargin,
                                                         kYQImageSectionMargin);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellReuseIdentifier];
    [self updateItemSize];
    collectionViewLayout.itemSize = [self itemSize];
}

- (void)updateInterFace{
    self.collectionView.hidden = self.selectedPhotos.count == 0;
    if (self.collectionView.hidden == NO) {
        [self.collectionView reloadData];
    }
    
    self.singleImageView.hidden = self.selectedImage == nil;
    if (self.selectedImage) {
        self.singleImageView.image = self.selectedImage;
    }
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

- (YQPhotoPicker *)picker{
    if (!_picker) {
        _picker = [[YQPhotoPicker alloc] init];
        _picker.delegate = self;
        _picker.baseViewController = self;
        _picker.allowEditing = YES;
        _picker.editStyle = YQEditSelectImageViewShapeStyle_rect;
        _picker.ratioW_Y = 1;
        _picker.suitableWidth = [UIScreen mainScreen].bounds.size.width;
        _picker.selectedImages = self.selectedPhotos;
        _picker.allowMaxNumber = 40;
    }
    return _picker;
}

#pragma mark - action
- (IBAction)pickSingle:(id)sender {
    [self.picker picktSinglePhoto];
}

- (IBAction)pickMultiple:(id)sender {
    self.picker.selectedImages = (NSArray<YQSelectedPhoto *> *)self.selectedImage;
    [self.picker pickMultiPhtots];
}

#pragma mark - UIConllectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    id<YQImage>image = self.selectedPhotos[indexPath.item];
    [imageView setAsynchronousImage:image width:self.itemSize.width height:self.itemSize.height];
    
    return cell;
}

#pragma mark - YQPhotoPickerDelegate
// 选择照片完成(单张)
- (void)photoPicker:(YQPhotoPicker *)photoPicker didSelectImage:(YQSelectedPhoto *)selectPhoto{
    self.selectedPhotos = nil;
    self.selectedImage = selectPhoto.editImage;
    [self updateInterFace];
}
// 选择照片完成(多张)
- (void)photoPicker:(YQPhotoPicker *)photoPicker didSelectImages:(NSArray<YQSelectedPhoto *> *)selectPhotos{
    self.selectedImage = nil;
    self.selectedPhotos = selectPhotos;
    [self updateInterFace];
}

@end
