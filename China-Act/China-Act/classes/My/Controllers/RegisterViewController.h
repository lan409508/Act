//
//  RegisterViewController.h
//  China-Act
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)huoquyanzhengBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;



@end
