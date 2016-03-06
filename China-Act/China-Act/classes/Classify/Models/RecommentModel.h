//
//  RecommentModel.h
//  China-Act
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommentModel : NSObject
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *name;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
