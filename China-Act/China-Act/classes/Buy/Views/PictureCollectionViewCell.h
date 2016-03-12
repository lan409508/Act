//
//  PictureCollectionViewCell.h
//  
//
//  Created by scjy on 16/3/11.
//
//

#import <UIKit/UIKit.h>
#import "BuyModel.h"
@interface PictureCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *MyImage;
@property (nonatomic,strong)UILabel * myTitle;
@property (nonatomic,strong)BuyModel * model;
@property (nonatomic,strong)NSData * data;

@end
