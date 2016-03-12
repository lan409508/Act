//
//  RegisterViewController.m
//  China-Act
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+Common.h"
#import "ProgressHUD.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobSMS.h>

static NSString *code = @"20027";

@interface RegisterViewController ()

//- (NSString *)valiMobile:(NSString *)mobile;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    self.passwordTF.secureTextEntry = YES;
    [self showBackBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [ProgressHUD dismiss];
}

- (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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



- (IBAction)huoquyanzhengBtn:(id)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneTF.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",number);
        }
    }];
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneTF.text andSMSCode:code resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (IBAction)registerBtn:(id)sender {
    if (![self checkOut]) {
        return ;
    }
//    [ProgressHUD show:@"注册中"];
    
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.phoneTF.text];
    [bUser setPassword:self.passwordTF.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
//            [ProgressHUD showSuccess:@"注册成功"];
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"恭喜你" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                LXJLog(@"取消");
                
            }];
            
            
            [alertC addAction:alertAc];
            [alertC addAction:cancelAc];
            [self presentViewController:alertC animated:NO completion:^{
                
            }];
            
            
            
            
        }else {
//            [ProgressHUD showError:@"用户名已存在"];
            LXJLog(@"注册失败");
            
        }
    }];

}


- (BOOL)checkOut {
    if ([self valiMobile:self.phoneTF.text]) {
        LXJLog(@"请输入正确的手机号");
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            
        }];
        UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.phoneTF.text = nil;
            self.passwordTF.text = nil;
        }];
        
        
        [alertC addAction:alertAc];
        [alertC addAction:cancelAc];
        [self presentViewController:alertC animated:NO completion:^{
            
        }];
        return NO;
    }
    if (self.passwordTF.text.length < 6) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确格式的密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            
        }];
        UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.phoneTF.text = nil;
            self.passwordTF.text = nil;
        
        }];
        
        
        [alertC addAction:alertAc];
        [alertC addAction:cancelAc];
        [self presentViewController:alertC animated:NO completion:^{
            
        }];
        return NO;
    }
    return YES;
}

@end
