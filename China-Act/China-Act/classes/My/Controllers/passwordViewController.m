//
//  passwordViewController.m
//  China-Act
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "passwordViewController.h"
#import "UIViewController+Common.h"
@interface passwordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
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


@end
