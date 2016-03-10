//
//  BuyCollectionViewCell.m
//  China-Act
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "BuyCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BuyCollectionViewCell

- (void)setBModel:(BuyModel *)BModel {
    [self.myImageV sd_setImageWithURL:[NSURL URLWithString:BModel.images] placeholderImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _myImageV = [[UIImageView alloc]init];
        [self.contentView addSubview:_myImageV];
        
    }
    return self;
}

// 自定义Layout
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    _myImageV.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
    
}

@end
