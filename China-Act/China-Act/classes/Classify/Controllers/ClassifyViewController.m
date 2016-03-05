//
//  ClassifyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
@interface ClassifyViewController ()

@property (nonatomic, strong) VOSegmentedControl *segmentControl;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.segmentControl];
    
}

#pragma mark -------- segmentControl

-(VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"推荐"},@{VOSegmentText:@"榜单"},@{VOSegmentText:@"类别"}]];
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.textColor = [UIColor lightGrayColor];
        self.segmentControl.selectedTextColor = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:158/255.0 alpha:1.0];
        self.segmentControl.selectedIndicatorColor = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:160/255.0 alpha:1.0];
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(0, 30, kWidth, 40);
        self.segmentControl.selectedSegmentIndex = 0;
        self.segmentControl.indicatorThickness = 4;
        
        [self.view addSubview:self.segmentControl];
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
            
        }];
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (void)segmentCtrlValuechange:(VOSegmentedControl *)segment{
    self.classifyListType = segment.selectedSegmentIndex - 1;
    [self chooseResquest];
}

- (void)chooseResquest{
    switch (self.classifyListType) {
        case ClassifyListTypeRecommended:
            [self getRecommendedRequest];
            break;
        case ClassifyListTypeList:
            [self getListRequest];
            break;
        case ClassifyListTypeCategory:
            [self getCategoryRequest];
            break;
        default:
            break;
    }
}

#pragma mark --------- Custom Method

- (void)getRecommendedRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kRecommend parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LXJLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getListRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getCategoryRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kCategory parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
