//
//  HWDefine.h
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#ifndef HWDefine_h
#define HWDefine_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ClassifyListType) {
    ClassifyListTypeRecommended = 0,
    ClassifyListTypeList,
    ClassifyListTypeCategory,
};

//首页接口
#define kMain @"http://api.playsm.com/index.php?size=10&r=message%2Flist&"

//首页广告接口
#define ad @"http://api.playsm.com/index.php?size=999&r=adImage%2Flist&customPosition=1&page=1&"
//详情接口
#define kDetail @"http://api.playsm.com/index.php?withContent=1&r=message%2Fdetail&withPraise=1&id=17727&pushtype=0&"
//更新接口
#define kGengxin @"http://api.playsm.com/index.php?size=20&r=cartoonCategory%2FgetCartoonSetListByCategory&id=20&page=1&"
//推荐
#define kTuijian @"http://api.playsm.com/index.php?size=20&r=cartoonBillBoard%2FgetCartoonSetListByBillBoard&id=3&page=1&"
//收藏
#define KShoucang @"http://api.playsm.com/index.php?size=20&r=cartoonBillBoard%2FgetCartoonSetListByBillBoard&id=4&page=1&"
//最新
#define kZuixin @"http://api.playsm.com/index.php?size=20&r=cartoonCategory%2FgetCartoonSetListByCategory&id=21&page=1&"
//推荐滚动接口
#define kRSCroll @"http://api.playsm.com/index.php?size=999&r=adImage%2Flist&customPosition=2&page=1&"
//榜单接口
#define kList @"http://api.playsm.com/index.php?size=10&r=cartoonBillBoard%2Flist&page=1&"
//类别接口
#define kCategory @"http://api.playsm.com/index.php?size=999&r=cartoonCategory%2Flist&page=1&"
#endif /* HWDefine_h */
