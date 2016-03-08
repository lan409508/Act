//
//  ClassifyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ClassifyViewController.h"
#import "RecommentModel.h"
#import "RecommentCollectionReusableView.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProgressHUD.h"
#import "CDetailViewController.h"

   static NSString *itemIdentifier = @"itemIdentifier";
   static NSString *headerIdentifier = @"headerIdentifier";

@interface ClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *mainArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0]}];
     [self.view addSubview:self.collectionView];
    [self getRecomment];
}

#pragma mark -------- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    RecommentModel *model = self.mainArray[indexPath.row];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 55.0;
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, self.layout.itemSize.width, self.layout.itemSize.height)];
    self.titleLabel.text = model.title;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:imageV];
    [cell addSubview:self.titleLabel];
    
    return cell;
}

#pragma mark --------- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CDetailViewController *DetailVC = [[CDetailViewController alloc] init];
    RecommentModel *model = self.mainArray[indexPath.row];
    DetailVC.CDetailID = model.classifyId;
    [self.navigationController pushViewController:DetailVC animated:YES];
}


#pragma mark --------- Custom Method
- (void)getRecomment {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kCategory parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *error = dic[@"error"];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                RecommentModel *model = [[RecommentModel alloc] initWithDictionary:dict];
                [self.mainArray addObject:model];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


#pragma mark -------- lazy loading

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumLineSpacing = 25;
        self.layout.minimumInteritemSpacing = 1;
        self.layout.headerReferenceSize = CGSizeMake(kWidth, 40);
        self.layout.footerReferenceSize = CGSizeMake(kWidth, 40);
        self.layout.itemSize = CGSizeMake(110, 110);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)mainArray {
    if (_mainArray == nil) {
        self.mainArray = [NSMutableArray new];
    }
    return _mainArray;
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
