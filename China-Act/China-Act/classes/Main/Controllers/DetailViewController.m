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

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self showBackBtn];
    
    if (self.judg == YES) {
        [self getDetailHtml:self.detailId];
    }else {
    [self getDetailUrl:self.detailId];
    }
    
    
}

-(void)getDetailHtml:(NSString *)hrml{

    [self.webView loadHTMLString:hrml baseURL:nil];

}

-(void)getDetailUrl:(NSString *)url{

    NSURL *str = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:str];
    [self.webView loadRequest:request];
    

}

-(UIWebView *)webView{

    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, kWidth, kHeight - 100)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
        self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:self.webView];
        
        
    }
    return _webView;
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
