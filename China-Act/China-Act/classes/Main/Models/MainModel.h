//
//  MainModel.h
//  China-Act
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *QuFen;
@property (nonatomic, strong) NSString *adImage;
@property (nonatomic, strong) NSString *adTitle;
@property (nonatomic, strong) NSString *params;
@property (nonatomic, strong) NSString *share;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *content;

-(instancetype)initWithDictonary:(NSDictionary *)dict rType:(NSString *)rType;

@end
