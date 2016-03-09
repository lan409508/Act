//
//  AppDelegate.m
//  China-Act
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>

@end

@interface WBBaseRequest ()
-(void)debugPrint;
@end

@interface WBBaseResponse ()
-(void)debugPrint;
@end

@implementation AppDelegate

@synthesize wbToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //新浪微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAPPkey];
    //微信注册
    [WXApi registerApp:kWeiXinAppkey];
    
    self.tabBarVC = [[UITabBarController alloc]init];
    //主页
    UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *MainNav = MainSB.instantiateInitialViewController;
    MainNav.tabBarItem.image = [UIImage imageNamed:@"zixun_new2"];
    UIImage *selectImage = [UIImage imageNamed:@"zixun_new1"];
    MainNav.tabBarItem.title = @"萌资讯";
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    MainNav.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //分类
    UIStoryboard *ClassifySB = [UIStoryboard storyboardWithName:@"Classify" bundle:nil];
    UINavigationController *ClassifyNav = ClassifySB.instantiateInitialViewController;
    ClassifyNav.tabBarItem.image = [UIImage imageNamed:@"manhua_new2"];
    UIImage *selectImage1 = [UIImage imageNamed:@"manhua_new1"];
    ClassifyNav.tabBarItem.title = @"漫画";
    ClassifyNav.tabBarItem.selectedImage = [selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //购物车
    UIStoryboard *BuySB = [UIStoryboard storyboardWithName:@"Buy" bundle:nil];
    UINavigationController *BuyNav = BuySB.instantiateInitialViewController;
    BuyNav.tabBarItem.image = [UIImage imageNamed:@"meitu_new2"];
    UIImage *selectImage2 = [UIImage imageNamed:@"meitu_new1"];
    BuyNav.tabBarItem.title = @"美图";
    BuyNav.tabBarItem.selectedImage = [selectImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //我的
    UIStoryboard *MySB = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    UINavigationController *MyNav = MySB.instantiateInitialViewController;
    MyNav.tabBarItem.image = [UIImage imageNamed:@"mengwo_new2"];
    UIImage *selectImage3 = [UIImage imageNamed:@"mengwo_new1"];
    MyNav.tabBarItem.title = @"萌窝";
    MyNav.tabBarItem.selectedImage = [selectImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _tabBarVC.viewControllers = @[MainNav,ClassifyNav,BuyNav,MyNav];
    self.window.rootViewController = _tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -------- 微博代理方法
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}

#pragma mark -------- 微信代理方法


#pragma mark -------- SDK

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
