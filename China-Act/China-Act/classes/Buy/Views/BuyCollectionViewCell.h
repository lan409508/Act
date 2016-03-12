//
//  BuyCollectionViewCell.h
//  China-Act
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyModel.h"
@interface BuyCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *MyImage;
@property (nonatomic,strong)UILabel * myTitle;
@property (nonatomic,strong)BuyModel * model;
@property (nonatomic,strong)NSData * data;

@end
