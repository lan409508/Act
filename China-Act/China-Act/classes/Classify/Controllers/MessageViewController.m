//
//  MessageViewController.m
//  China-Act
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MessageViewController.h"
#import "UIViewController+Common.h"
#import "CDetailModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageDetailViewController.h"

static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";

@interface MessageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuijingengxin;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *headerCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *dataAry;
@property (strong, nonatomic) NSMutableArray *numberArray;
@property (strong, nonatomic) UIButton *numBtn;
@property (strong, nonatomic) UIView *btnV;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    [self getModel];
    [self showBackBtn];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
//    CDetailModel *model = self.numberArray[indexPath.row];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height)];
    numLabel.text = [NSString stringWithFormat:@"%ld话",indexPath.row];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor lightGrayColor];
    [cell setBackgroundView:numLabel];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailViewController *messVC = [MessageDetailViewController alloc];
    CDetailModel *model = self.numberArray[indexPath.row];
    messVC.MeDId = model.Id;
    [self.navigationController pushViewController:messVC animated:YES];
}

- (void)getModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kMessage,self.messageId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSDictionary *dict = dic[@"results"];
            NSArray *numAry = dict[@"cartoonChapterList"];
            for (NSDictionary *numDic in numAry) {
                CDetailModel *numModel = [[CDetailModel alloc] initWithDictionary:numDic];
                [self.numberArray addObject:numModel];
            }
          
            CDetailModel *model = [[CDetailModel alloc] initWithDictionary:dict];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:nil];
            self.titleLabel.text = model.name;
            self.authorLabel.text = model.author;
            self.updateTimeLabel.text = model.updateValueLabel;
            self.zuijingengxin.text = model.recentUpdateTime;
            self.contentLabel.text = model.introduction;
        }
        [self.view addSubview:self.collectionView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumInteritemSpacing = 1;
        self.layout.minimumLineSpacing = 3;
        self.layout.footerReferenceSize = CGSizeMake(kWidth, 60);
        self.layout.itemSize = CGSizeMake(80, 40);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 350, kWidth - 20, 327) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)dataAry {
    if (_dataAry == nil) {
        self.dataAry = [NSMutableArray new];
    }
    return _dataAry;
}

- (NSMutableArray *)numberArray {
    if (_numberArray == nil) {
        self.numberArray = [NSMutableArray new];
    }
    return _numberArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
