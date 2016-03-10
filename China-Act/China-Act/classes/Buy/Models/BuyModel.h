//
//  BuyModel.h
//  China-Act
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyModel : NSObject

@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *width;
@property (strong, nonatomic) NSString *height;

- (instancetype)initWithDictionary:(NSDictionary *)dataDic;


@end
