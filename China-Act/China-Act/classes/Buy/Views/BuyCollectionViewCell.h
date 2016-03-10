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

@property (nonatomic, strong) UIImageView *myImageV;
@property (nonatomic, strong) BuyModel *BModel;
@property (nonatomic, strong) NSData *data;

@end
