//
//  CDetailModel.m
//  China-Act
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "CDetailModel.h"

@implementation CDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dataDic {
    if (self) {
        self.Id = dataDic[@"id"];
        self.images = dataDic[@"images"];
        self.introduction = dataDic[@"introduction"];
        self.name = dataDic[@"name"];
        self.updateInfo = dataDic[@"updateInfo"];
        self.cartoonId = dataDic[@"cartoonId"];
        self.author = dataDic[@"author"];
        self.recentUpdateTime = dataDic[@"recentUpdateTime"];
        self.updateValueLabel = dataDic[@"updateValueLabel"];
        self.chapterId = dataDic[@"chapterId"];
        self.width = dataDic[@"imgWidth"];
        self.height = dataDic[@"imgHeight"];
    }
    return self;
}

@end
