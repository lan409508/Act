//
//  CDetailViewController.m
//  
//
//  Created by scjy on 16/3/8.
//
//

#import "CDetailViewController.h"
#import "UIViewController+Common.h"
#import "MJRefresh.h"
#import "CDetailModel.h"
#import <AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClassifyViewController.h"
#import "MessageViewController.h"

static NSString *itemIdentifier = @"itemIdentifier";

@interface CDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *BigArray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL refreshing;

@end

@implementation CDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    self.title = self.titleL;
    _pageCount = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBackBtn];
    [self getModel];
    [self refreshingAction];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.BigArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    CDetailModel *model = self.BigArray[indexPath.row];
    for (UIView *viewi in cell.contentView.subviews) {
        [viewi removeFromSuperview];
        
    }
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height - kWidth *4/75)];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:nil];

    [cell.contentView addSubview:self.imageV];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Classify" bundle:[NSBundle mainBundle]];                       MessageViewController *messageVC = [story instantiateViewControllerWithIdentifier:@"messageVC"];
    CDetailModel *model = self.BigArray[indexPath.row];
    messageVC.messageId = model.Id;
    [self.navigationController pushViewController:messageVC animated:YES];
    
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

- (void)getModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@&page=%ld",kCDetail,self.CDetailID,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *error = dic[@"error"];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                CDetailModel *model = [[CDetailModel alloc] initWithDictionary:dict];
                [self.BigArray addObject:model];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumInteritemSpacing = 1;
        self.layout.minimumLineSpacing = 1;
//        self.layout.headerReferenceSize = CGSizeMake(kWidth, (kWidth * 6/75));
        self.layout.itemSize = CGSizeMake((kWidth * 118/375), kHeight / 4);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((kWidth * 1/75), 0, kWidth - (kWidth * 3/75), kHeight - (kHeight * 3/75)) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)BigArray {
    if (_BigArray == nil) {
        self.BigArray = [NSMutableArray new];
    }
    return _BigArray;
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
