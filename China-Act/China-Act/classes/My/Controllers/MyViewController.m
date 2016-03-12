//
//  MyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MyViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "ProgressHUD.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WXApiDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) UILabel *nikeNamelabel;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIButton *btn;
//@property (nonatomic, strong) UIButton *btn1;
//@property (nonatomic, strong) UIButton *btn2;
//@property (nonatomic, strong) UIButton *btn3;
//@property (nonatomic, strong) UIButton *btn4;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:65/255.0 blue:83/255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.nikeNamelabel];
    [self.view addSubview:self.btn];
    self.imageArray = @[@"huancun",@"mianze",@"jieshouxiaoxi",@"genxin_seting",];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"分享",@"接收消息",@"检查更新",nil];
}

- (void)viewWillAppear:(BOOL)animated{
    //当页面将要出现的时候重新计算图片缓存大小
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.2fM)",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark -------- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //去掉cell选中颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

#pragma mark -------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除缓存?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                LXJLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                [imageCache clearDisk];
                [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
            UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
            break;
    
        case 1:
        {
            //分享
            [self share];
        }
            
            break;
        case 2:
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要接收消息?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.titleArray replaceObjectAtIndex:2 withObject:@"接收消息"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测中..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        default:
            break;
    }
}

#pragma mark -------- lazy loading

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kWidth, kWidth, kHeight - kHeight * 30/667) style:UITableViewStylePlain];
        self.tableView.separatorColor = [UIColor darkGrayColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}

- (UIButton *)btn {
    if (_btn == nil) {
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(kWidth * 1/3, kHeight *230/667,kWidth * 4/15, kHeight *25/667);
        [self.btn setTitle:@"登录" forState:UIControlStateNormal];
        self.btn.layer.cornerRadius = 5;
        self.btn.clipsToBounds = YES;
        [self.btn setBackgroundColor:[UIColor whiteColor]];
        [self.btn setTitleColor:[UIColor colorWithRed:252/255.0 green:68/255.0 blue:96/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIButton *)headImageBtn {
    if (_headImageBtn == nil) {
        self.headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageBtn.frame = CGRectMake(135, 140, 80, 80);
        [self.headImageBtn setImage:[UIImage imageNamed:@"header_nologin"] forState:UIControlStateNormal];
        [self.headImageBtn setBackgroundColor:[UIColor whiteColor]];
        [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headImageBtn.layer.cornerRadius = 40.0;
        self.headImageBtn.clipsToBounds = YES;
    }
    return _headImageBtn;
}

- (UILabel *)nikeNamelabel {
    if (_nikeNamelabel == nil) {
        self.nikeNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 85, 200, 80)];
        self.nikeNamelabel.text =@"登录后开始卖萌呦(*^ω^*)";
        self.nikeNamelabel.textColor = [UIColor whiteColor];
    }
    return _nikeNamelabel;
}

- (void)share{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.grayView.backgroundColor = [UIColor colorWithRed:252/255.0 green:65/255.0 blue:83/255.0 alpha:1.0];
    self.grayView.alpha = 0.3;
    [window addSubview:self.grayView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 200, kWidth, 250)];
    self.shareView.backgroundColor = [UIColor colorWithRed:252/255.0 green:65/255.0 blue:83/255.0 alpha:1.0];
    [window addSubview:self.shareView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, kHeight - 250, kWidth, 250);
    }];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 100, 44)];
    label.text = @"分享到";
    label.textColor = [UIColor blackColor];
    [self.shareView addSubview:label];
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(40, 40, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"share_weibo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(SendRequest) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 70, 20)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textColor = [UIColor whiteColor];
    weiboLabel.font = [UIFont systemFontOfSize:13.0];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboLabel];
    [self.shareView addSubview:weiboBtn];
    
    //朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(150, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friend) forControlEvents:UIControlEventTouchUpInside];
    UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 100, 70, 20)];
    friendLabel.text = @"微信好友";
    friendLabel.textColor = [UIColor whiteColor];
    friendLabel.font = [UIFont systemFontOfSize:13.0];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:friendLabel];
    [self.shareView addSubview:friendBtn];
    
    //朋友圈
    UIButton *quanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quanBtn.frame = CGRectMake(260, 40, 70, 70);
    [quanBtn setImage:[UIImage imageNamed:@"share_wxcircle"] forState:UIControlStateNormal];
    [quanBtn addTarget:self action:@selector(testMessagesAct) forControlEvents:UIControlEventTouchUpInside];
    UILabel *quanLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 100, 70, 20)];
    quanLabel.text = @"微信朋友圈";
    quanLabel.textColor = [UIColor whiteColor];
    quanLabel.font = [UIFont systemFontOfSize:13.0];
    quanLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:quanLabel];
    [self.shareView addSubview:quanBtn];
    
    //QQ
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(kWidth * 8/75, 100, 70, 70);
    [self.shareView addSubview:qqBtn];
    
    //qq空间
    
    
    //remove
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, 200, kWidth, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    removeBtn.backgroundColor = [UIColor whiteColor];
    [removeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
}

- (void)testMessagesAct{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"这是测试发送的内容。";
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"已是最新版本"];
}

- (void)friend {
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"这是测试发送的内容。";
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)remove {
    [self.shareView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)SendRequest {
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbToken];
    request.userInfo = @{@"ShareMessageFrom": @"MeViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [self remove];
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"啊啊啊，，，头要炸啦";
    return message;
}



- (void)login {
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    UINavigationController *nav = [loginSB instantiateViewControllerWithIdentifier:@"LoginNav"];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)sendEmail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
            //设置代理
            mailVC.mailComposeDelegate= self;
            //设置主题
            [mailVC setSubject:@"用户反馈"];
            //设置收件人
            NSArray *receive = [NSArray arrayWithObjects:@"2742684905@qq.com",nil];
            [mailVC setToRecipients:receive];
            
            //设置发送内容
            NSString *text = @"留下您宝贵的意见";
            [mailVC setMessageBody:text isHTML:NO];
            
            //推出视图
            [self presentViewController:mailVC animated:YES completion:nil];
        } else {
            LXJLog(@"未配置邮箱");
        }
    } else {
        LXJLog(@"当前设备不支持");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
