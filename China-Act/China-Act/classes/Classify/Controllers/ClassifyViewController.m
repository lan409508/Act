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

   static NSString *itemIdentifier = @"itemIdentifier";
   static NSString *headerIdentifier = @"headerIdentifier";

@interface ClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *mainArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger Category;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self getRecomment];
}

#pragma mark --------- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark --------- Custom Method
- (void)getRecomment {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kRecomment parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark --------- lazy loading
- (NSMutableArray *)mainArray {
    if (_mainArray == nil) {
        self.mainArray = [NSMutableArray new];
    }
    return _mainArray;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        //设置每一行的间距
        self.layout.minimumLineSpacing = 3;
        //设置item的间距
        self.layout.minimumInteritemSpacing = 1;
        //设置区头区尾的大小
        self.layout.headerReferenceSize = CGSizeMake(kWidth, 30);
        if (self.Category == ClassifyListTypeList) {
            self.layout.itemSize = CGSizeMake(kWidth, kHeight / 3);
        } else if (self.Category == ClassifyListTypeCategory) {
            self.layout.itemSize = CGSizeMake(kWidth / 3, kHeight / 3);
            self.layout.minimumLineSpacing = 1;
            self.layout.minimumInteritemSpacing = 1;
        }
        //设置每个item的大小
        self.layout.itemSize = CGSizeMake(kWidth / 3 - 3, kHeight / 4);
        //通过一个layout布局来创建CollectionView
        self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, kWidth, kHeight - 130) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        //注册头部
        [self.collectionView registerNib:[UINib nibWithNibName:@"RecommentCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
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
