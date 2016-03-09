//
//  LoginViewController.m
//  China-Act
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *deluBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuceBtn;
@property (weak, nonatomic) IBOutlet UIButton *wangjiBtn;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
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

@end