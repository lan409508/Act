//
//  MainViewController.m
//  China-Act
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullingRefreshTableView.h"
#import "HWtools.h"
#import "MainModel.h"
#import "MainTableViewCell.h"



@interface MainViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property (nonatomic, strong) UIView *headerTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *adArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏右键
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0]}];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110;
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    [self loadData];
    [self getModel];
    [self HeaderTableView];
}

#pragma mark -------- lazy loading

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 44) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
        self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 130);
        
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(200, 130, 100, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

#pragma mark -------- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.listArray.count) {
        mainCell.mainModel = self.listArray[indexPath.row];
    }

    return mainCell;
}


//上拉开始刷新
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}

#pragma mark --------- CostumMethod
- (void)HeaderTableView {
    self.headerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
    [self.headerTableView addSubview:self.scrollView];
    self.pageControl.numberOfPages = self.adArray.count;
    
    [self.headerTableView addSubview:self.pageControl];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 130)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"images"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
    }
    self.tableView.tableHeaderView = self.headerTableView;
}

- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:ad parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""]&& code == 0) {
            NSString *rType = dic[@"params"][@"r"];
            NSArray *array = dic[@"results"];
            for (NSDictionary *dict in array) {
                MainModel *model = [[MainModel alloc]initWithDictonary:dict rType:rType];
                [self.adArray addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
   [sessionManager GET:[NSString stringWithFormat:@"%@page=%ld",kMain,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//       NSLog(@"%@",downloadProgress);
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSDictionary *dic = responseObject;
       NSInteger code = [dic[@"code"] integerValue];
       NSString *error = dic[@"error"];
       if ([error isEqualToString:@""] && code == 0 ) {
            NSString *rType = dic[@"params"][@"r"];
           NSArray *array = dic[@"results"];
           for (NSDictionary *dict in array) {
               MainModel *model = [[MainModel alloc]initWithDictonary:dict rType:rType];
                [self.listArray addObject:model];
           }
       }
       [self.tableView reloadData];
//       NSLog(@"%@",responseObject);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     //  NSLog(@"%@",error);
   }];
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
