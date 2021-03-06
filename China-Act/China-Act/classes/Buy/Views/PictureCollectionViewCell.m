//
//  PictureCollectionViewCell.m
//  
//
//  Created by scjy on 16/3/11.
//
//

#import "PictureCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PictureCollectionViewCell

-(void)setModel:(BuyModel *)model
{
    [self.MyImage sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:nil];
    
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PictureCollectionViewCell" owner:self options:nil];
        self = [arrayOfViews objectAtIndex:0];
        _MyImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_MyImage];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
    }
    return self;
}
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    _MyImage.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
    
}

@end
