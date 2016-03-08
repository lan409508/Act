//
//  DetailView.m
//  China-Act
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DetailView.h"

@interface DetailView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    [self drawContentWithArray:dataDic[@"url"]];
}

- (void)drawContentWithArray:(NSArray *)dataArray {
    
}

- (void)configView {
    [self addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(kWidth, 5000);
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    }
    return _scrollView;
}

@end
