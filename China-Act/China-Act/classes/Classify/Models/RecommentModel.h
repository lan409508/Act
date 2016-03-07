//
//  RecommentModel.h
//  China-Act
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommentModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rType;

- (instancetype)initWithDictionary:(NSDictionary *)dataDic;

@end
