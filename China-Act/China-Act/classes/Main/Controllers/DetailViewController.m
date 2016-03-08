//
//  DetailViewController.m
//  China-Act
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "UIViewController+Common.h"
#import "MainModel.h"
@interface DetailViewController ()

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
    [self showBackBtn];
    [self getModel];
    
}

- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kDetail,self.detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
//        NSString *rType = dic[@"r"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                self.navigationItem.title = dict[@"title"];
                [self.listArray addObject:dict[@"shareUrl"]];
                
            }
        }
//        [self.scrollView  ];
//        [self.scrollView addSubview:<#(nonnull UIView *)#>];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.contentSize = CGSizeMake(kWidth, 2000);
    }
    return _scrollView;
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
