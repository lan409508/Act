//
//  RecommentCollectionReusableView.h
//  China-Act
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommentModel.h"
@interface RecommentCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) RecommentModel *recommentModel;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@end
