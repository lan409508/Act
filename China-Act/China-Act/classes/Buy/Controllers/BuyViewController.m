//
//  BuyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyCollectionViewCell.h"
#import "BuyModel.h"
#import "HeaderCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>

static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headerItemIdentifier = @"headeritemIdentifier";
static NSString *footerItemIdentifier = @"footeritemIdentifier";

@interface BuyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray  *heightArr;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong)UIImage * image; // 如果计算图片尺寸失败  则下载图片直接计算
@property (nonatomic,strong)NSMutableArray * heightArray;// 存储图片高度的数组
@property (nonatomic,strong)NSMutableArray * modelArray; //存储 model 类的数组

@property (nonatomic,assign)NSInteger page; // 一次刷新的个数

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美图";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0]}];
    [self getModel];
    [self.view addSubview:self.collectionView];
}

- (void)getModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kPicture parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumLineSpacing = 1;
        self.layout.minimumInteritemSpacing = 0.1;
        self.layout.headerReferenceSize = CGSizeMake(kWidth, kWidth *3/75);
        self.layout.footerReferenceSize = CGSizeMake(kWidth, kWidth *7/75);
        self.layout.itemSize = CGSizeMake(kWidth * 11/24, kHeight/3);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kWidth * 2/75, 0, kWidth - (kWidth * 3/75), kHeight - (kHeight * 3/75)) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)modelArray {
    if (_modelArray == nil) {
        self.modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (NSMutableArray *)heightArr {
    if (_heightArr == nil) {
        self.heightArr = [NSMutableArray new];
    }
    return _heightArr;
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
