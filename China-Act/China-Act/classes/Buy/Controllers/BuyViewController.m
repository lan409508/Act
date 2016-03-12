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
#import "PictureViewController.h"
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
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美图";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    [self getModel];
    [self.view addSubview:self.collectionView];
}

- (void)getModel {
    NSString *searchLabel = [self.labelID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kPList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *array = dic[@"results"];
            for (NSString *label in array) {
                [self.nameArray addObject:label];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(0, (kWidth *4/75), cell.frame.size.width/2, cell.frame.size.height/2);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = self.nameArray[indexPath.row];
    self.nameLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundView:self.nameLabel];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewController *picVC = [[PictureViewController alloc] init];
    picVC.labelId = self.nameArray[indexPath.row];
    [self.navigationController pushViewController:picVC animated:YES];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumLineSpacing = 1;
        self.layout.minimumInteritemSpacing = 0.1;
        self.layout.headerReferenceSize = CGSizeMake(kWidth, kWidth *3/75);
        self.layout.footerReferenceSize = CGSizeMake(kWidth, kWidth *2/75);
        self.layout.itemSize = CGSizeMake(kWidth * 5/16, kWidth * 11/96);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kWidth * 2/75, 0, kWidth - (kWidth * 3/75), kHeight - (kHeight * 2/75)) collectionViewLayout:self.layout];
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

- (NSMutableArray *)nameArray {
    if (_nameArray == nil) {
        self.nameArray = [NSMutableArray new];
    }
    return _nameArray;
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
