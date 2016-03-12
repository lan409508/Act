//
//  BuyModel.m
//  China-Act
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "BuyModel.h"

@implementation BuyModel

- (instancetype)initWithDictionary:(NSDictionary *)dataDic{
    if (self) {
        self.images = dataDic[@"images"];
        self.width = dataDic[@"width"];
        self.height = dataDic[@"height"];
        self.url = dataDic[@"sourceImages"];
    }
    return self;
}

@end
