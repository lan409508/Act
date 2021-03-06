//
//  MainModel.m
//  China-Act
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

-(instancetype)initWithDictonary:(NSDictionary *)dict rType:(NSString *)rType{
    self = [super init];
    if (self) {
        self.params = dict[@"params"];
        self.QuFen = rType;
        self.share = dict[@"shareUrl"];
        self.ID = dict[@"id"];
        if ([self.QuFen isEqualToString:@"message/list"]) {
            self.image = dict[@"images"];
            self.title = dict[@"title"];
            self.time = dict[@"createTimeValue"];
            self.author = dict[@"author"];
            
        }
        else if ([self.QuFen isEqualToString:@"adImage/list"]){
            self.adImage = dict[@"images"];
            self.adTitle = dict[@"title"];
            self.content = dict[@"messageinfo"][@"content"];
        }
    }
    return self;
}

@end
