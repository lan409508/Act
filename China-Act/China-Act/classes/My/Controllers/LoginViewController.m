//
//  LoginViewController.m
//  China-Act
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)dengluBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zhuceBtn;




@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarbtn;
    self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:226/225.0 green:62/225.0 blue:85/255.0 alpha:1.0];
    self.passwordTF.secureTextEntry = YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

//点击页面空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //第一种方式
    //    [self.userNameTF resignFirstResponder];
    //    [self.passwordTF resignFirstResponder];
    //    [self.confirmPassTF resignFirstResponder];
    //    [self.meilTF resignFirstResponder];
    
    //第二种方式
    [self.view endEditing:YES];
}

//- (void)ZhuceAction {
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:registerVC animated:YES];
//}


- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)dengluBtn:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.phoneTF.text password:self.passwordTF.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            LXJLog(@"登录成功");
        } else {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"哎呀呀" message:@"好像没网了哎..." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"再试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.phoneTF.text = nil;
                self.passwordTF.text = nil;
                
            }];
            UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"转身离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
}
@end
