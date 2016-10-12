//
//  YQAlbumListViewController.m
//  Demo
//
//  Created by maygolf on 16/9/19.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIImageView+YQAsynchronousImage.h"
#import "YQConstant.h"

#import "YQAlbumListViewController.h"

#import "YQAlbumTableViewCell.h"

#import "YQPhotoManager.h"
#import "PHAssetCollection+YQImage.h"

@interface YQAlbumListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *albumGroups;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *allAsset;

@end

@implementation YQAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self building];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加载数据
    [self loadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buildidng
- (void)building{
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"相册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
}

#pragma mark - loadData
- (void)loadData{
    
    // 默认包含所有照片条目
    self.albumGroups = [NSMutableArray array];
    [self addAlbumGroup:[YQPhotoManager allPhotoAlbums]];
    
    // 用户相册
    [self addAlbumGroup:[YQPhotoManager userAlbums]];
    
    // 智能相册
    [self addAlbumGroup:[YQPhotoManager smartAlbums]];
    
    // 照片流
    [self addAlbumGroup:[YQPhotoManager photoStreamAlbums]];
}

#pragma mark - private
- (void)addAlbumGroup:(NSArray<PHAssetCollection *> *)group{
    if (group.count) {
        [self.albumGroups addObject:group];
    }
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YQAlbumTableViewCell class] forCellReuseIdentifier:kAlbumTableViewCellReuseIdentity];
    }
    return _tableView;
}

#pragma mark - action
- (void)cancel:(UIBarButtonItem *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelect:)]) {
        [self.delegate cancelSelect:self];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kYQAlbumTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumListController:didSelected:)]) {
        NSArray *group = self.albumGroups[indexPath.section];
        PHAssetCollection *assetConllection = group[indexPath.row];
        [self.delegate albumListController:self didSelected:assetConllection];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.albumGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *assetColletions = self.albumGroups[section];
    return assetColletions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YQAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumTableViewCellReuseIdentity forIndexPath:indexPath];
    
    NSArray *group = self.albumGroups[indexPath.section];
    PHAssetCollection *assetConllection = group[indexPath.row];
    cell.nameLable.text = assetConllection.localizedTitle;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld张", (long)assetConllection.assetCount];
    [cell.posterView setAsynchronousImage:assetConllection
                                    width:kYQAlbumTableViewCellPosterViewSize
                                   height:kYQAlbumTableViewCellPosterViewSize
                               placeholer:kImgPlaceholder];
    
    return cell;
}

@end
