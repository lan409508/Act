//
//  PictureViewController.m
//  China-Act
//
//  Created by scjy on 16/3/11.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "PictureViewController.h"
#import "BuyModel.h"
#import "PictureCollectionViewCell.h"
#import "AoiroSoraLayout.h"
#import "BLImageSize.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>

static NSString *itemIdentifier = @"itemIdentifier";

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AoiroSoraLayoutDelegate>
{
    NSInteger _pageCount;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UIImageView *imagV;
@property (strong, nonatomic) NSMutableArray *bigArray;
@property (assign, nonatomic) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, assign) BOOL refreshing;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    [self.view addSubview:self.collectionView];
    self.listArray = [NSMutableArray new];
    self.heightArray = [NSMutableArray new];
    _pageCount = 1;
    [self getModel];
    [self refreshingAction];
}

-(void)refreshingAction{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshing = YES;
        [self.collectionView.mj_header beginRefreshing];
        [self.collectionView.mj_header endRefreshing];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self.collectionView.mj_footer beginRefreshing];
        _pageCount +=1;
        self.refreshing = NO;
        [self getModel];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}
-(void)getImageWithURL:(NSString *)url{
    CGSize  size = [BLImageSize dowmLoadImageSizeWithURL:url];
    NSInteger itemHeight = size.height * (((self.view.frame.size.width - 20) / 2 / size.width));
    
    NSNumber * number = [NSNumber numberWithInteger:itemHeight];
    
    [self.heightArray addObject:number];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        AoiroSoraLayout *layout = [[AoiroSoraLayout alloc] init];
        layout.interSpace = 5; // 每个item 的间隔
        layout.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.colNum = 2; // 列数;
        layout.delegate = self;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:layout];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:self.collectionView];
        
    }
    return  _collectionView;
}
#pragma mark -- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath
{
    if ([self.heightArray[indexPath.row] integerValue] < 0 || !self.heightArray[indexPath.row]) {
        
        return 150;
    }
    else
    {
        NSInteger intger = [self.heightArray[indexPath.row] integerValue];
        return intger;
    }
    
}

- (void)getModel {
    NSString *labId = [self.labelId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&searchLabel=%@&page=%ld",kPicture,labId,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *array = dic[@"results"];
            for (NSDictionary *dict in array) {
                BuyModel *model = [[BuyModel alloc] initWithDictionary:dict];
                [self.bigArray addObject:model];
                [self getImageWithURL:model.url];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bigArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    BuyModel *model = self.bigArray[indexPath.row];
    self.imagV = [[UIImageView alloc] initWithFrame:cell.frame];
    [self.imagV sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:nil];
    [cell setBackgroundView:self.imagV];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSMutableArray *)bigArray {
    if (_bigArray == nil) {
        self.bigArray = [NSMutableArray new];
    }
    return _bigArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
