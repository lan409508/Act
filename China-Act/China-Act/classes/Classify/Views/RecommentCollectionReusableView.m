//
//  RecommentCollectionReusableView.m
//  China-Act
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "RecommentCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RecommentCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RecommentCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(RecommentModel *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.titleLabel.text = model.introduce;
}
@end
