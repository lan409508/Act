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
#import "DetailViewController.h"
#import "PullingRefreshTableView.h"
#import "ProgressHUD.h"
#import "HWtools.h"
#import "MainModel.h"
#import "MainTableViewCell.h"
#import "LoginViewController.h"



@interface MainViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property (nonatomic, strong) UIView *headerTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
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
   
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110;
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    [self loadData];
    [self getModel];
    [self startTimer];
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
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight - (kHeight * 110/667))];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = kWidth * 44/75;
        self.tableView.pullingDelegate = self;
        self.tableView.separatorColor = [UIColor lightGrayColor];
        
        [self.view addSubview:self.tableView];    }
    return _tableView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
        self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 130);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(260, 130, 100, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self.pageControl addTarget:self action:@selector(pageSelect:) forControlEvents:UIControlEventValueChanged];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *mainModel = self.listArray[indexPath.row];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailVC"];
//    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.detailId = mainModel.share;
    [self.navigationController pushViewController:detailVC animated:YES];
}

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
        [self HeaderTableView];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)loadData{
//    [ProgressHUD showSuccess:@"完成刷新"];

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
           if (self.listArray.count > 0) {
               if (self.refreshing) {
                   [self.listArray removeAllObjects];
               }
           }
           for (NSDictionary *dict in array) {
               MainModel *model = [[MainModel alloc]initWithDictonary:dict rType:rType];
                [self.listArray addObject:model];
           }
       }
       [self.tableView tableViewDidFinishedLoading];
       [self.tableView reloadData];
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
   }];
}

//手指拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    [self startTimer];
}


- (void)HeaderTableView {
    self.headerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
    [self.headerTableView addSubview:self.scrollView];
    self.pageControl.numberOfPages = self.adArray.count;
    [self.headerTableView addSubview:self.pageControl];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 170)];
        MainModel *model = self.adArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.adImage] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth * i, 130, 250, 30)];
        titleLabel.text = model.adTitle;
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [UIColor whiteColor];
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:touchBtn];
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:titleLabel];
    
    }
    self.tableView.tableHeaderView = self.headerTableView;
}


#pragma mark --------- 滚动轮播图
//定时器
- (void)startTimer{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(roll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)roll{
    if (self.adArray.count > 0) {
        NSInteger page = (self.pageControl.currentPage + 1) % self.adArray.count;
        self.pageControl.currentPage = page;
        CGFloat offsetX = self.pageControl.currentPage * self.scrollView.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark --------- 轮播图

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGPoint offset = self.scrollView.contentOffset;
    NSInteger pageNum = offset.x / pageWidth;
    self.pageControl.currentPage = pageNum;
}

- (void)pageSelect:(UIPageControl *)pageControl {
    NSInteger pageNumber = pageControl.currentPage;
    CGFloat pageWidth = self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
}

- (void)touchAdvertisement:(UIButton *)btn {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    MainModel *model = self.adArray[btn.tag-100];
    detailVC.detailId = model.content;
    NSLog(@"%@",model.content);
    detailVC.judg = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
