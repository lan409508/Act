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
    ClassifyListTypeRecommended = 1,
    ClassifyListTypeList,
    ClassifyListTypeCategory,
};

//首页接口
#define kMain @"http://api.playsm.com/index.php?size=10&r=message%2Flist&"

//首页广告接口
#define ad @"http://api.playsm.com/index.php?size=999&r=adImage%2Flist&customPosition=1&page=1&"
#define adDetail @"http://api.playsm.com/index.php?withContent=1&r=message%2Fdetail&withPraise=1&id=17887&pushtype=2&";
//详情接口
#define kDetail @"http://api.playsm.com/index.php?withContent=1&r=message%2Fdetail&withPraise=1&id=17727&pushtype=0&"
//更新接口
#define kGengxin @"http://api.playsm.com/index.php?size=20&r=cartoonCategory%2FgetCartoonSetListByCategory&id=20&page=1&"
//漫画推荐接口
#define kRecomment @"http://api.playsm.com/index.php?size=999&r=recommend%2FgetUserRecommendList&page=1&"
//详情接口
#define kCDetail @"http://api.playsm.com/index.php?size=12&r=cartoonCategory%2FgetCartoonSetListByCategory&"
//内容接口
#define kMessage @"http://api.playsm.com/index.php?r=cartoonSet%2Fdetail&="
//漫画接口
#define kManhua @"http://api.playsm.com/index.php?size=10&orderType=1&r=cartoonChapter%2FalbumList&page=1&isSize=1&"
//
#define kRead @"http://api.playsm.com/index.php?size=10&orderType=1&r=cartoonChapter%2FalbumList&isSize=1&"
//推荐滚动接口
#define kRSCroll @"http://api.playsm.com/index.php?size=999&r=adImage%2Flist&customPosition=2&page=1&"
//榜单接口
#define kList @"http://api.playsm.com/index.php?size=10&r=cartoonBillBoard%2Flist&page=1&"
//类别接口
#define kCategory @"http://api.playsm.com/index.php?size=999&r=cartoonCategory%2Flist&page=1&"
//美图列表接口
#define kPList @"http://api.playsm.com/index.php?r=prettyImages%2FgetLabelList&"
//美图接口
#define kPicture @"http://api.playsm.com/index.php?lastCount=16&r=prettyImages%2Flist"
//新浪微博分享
#define kAPPkey @"1748121094"
#define kAppSecret @"146721be4d21f8e1756ec1fad00b4530"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
//微信分享
#define kWeiXinAppkey @"wx6c5be7db818032d8"
#define kWeiXinSecret @"d249cd8cb3ca0ead56569abd19a58df0"
//bmob
#define kBmonAppkey @"8cc30342f7f7a1b6d838e50a1f043c9b"
#endif /* HWDefine_h */
