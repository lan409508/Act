//
//  DetailView.m
//  China-Act
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DetailView.h"

@interface DetailView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation DetailView

- (void)awakeFromNib{
    self.scrollView.contentSize = CGSizeMake(kWidth, 5000);
}

-(void)setDetailModel:(MainModel *)detailModel{
    
}

@end
