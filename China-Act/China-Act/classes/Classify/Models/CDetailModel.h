//
//  CDetailModel.h
//  China-Act
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDetailModel : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *updateInfo;
@property (nonatomic, strong) NSString *cartoonId;
@property (nonatomic, strong) NSString *recentUpdateTime;
@property (nonatomic, strong) NSString *updateValueLabel;
- (instancetype)initWithDictionary:(NSDictionary *)dataDic;

@end
