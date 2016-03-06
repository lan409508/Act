//
//  RecommentModel.m
//  China-Act
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "RecommentModel.h"

@implementation RecommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self) {
        self.image = dict[@"images"];
        self.name = dict[@"name"];
    }
    return self;
}

@end
