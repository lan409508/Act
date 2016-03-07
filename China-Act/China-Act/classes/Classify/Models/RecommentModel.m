//
//  RecommentModel.m
//  China-Act
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "RecommentModel.h"

@implementation RecommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dataDic{
    if (self) {
        self.title = dataDic[@"title"];
        self.rType = dataDic[@"r"];
    }
    return self;
}

@end
