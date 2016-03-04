//
//  HWtools.h
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWtools : NSObject

#pragma mark ----------  时间转换相关的方法
//根据指定时间戳返回字符串类型时间
+ (NSString *)getDateFromString:(NSString *)timestamp;
//获取当前系统时间
+ (NSDate *)getSystemNowDate;

#pragma mark ----------  根据文字最大显示宽高和文字显示内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text BigestSize:(CGSize)bigSize textFont:(CGFloat)font;

@end
