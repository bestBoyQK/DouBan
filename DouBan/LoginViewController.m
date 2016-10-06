//
//  LoginViewController.m
//  DouBan
//


#import "LoginViewController.h"
#import "UserViewController.h"
#import "UserDataBase.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.HUD hide:YES];//隐藏加载器
    [self setDelegate];//设置代理
    //点击空白实现回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
   
    
}

//返回按钮实现事件
- (IBAction)backAction:(id)sender {
    //模态退出
    [self dismissViewControllerAnimated:YES completion:nil];

}

//实现用户登录点击事件
- (IBAction)loginAction:(id)sender {
    //通过用户名密码登录
    [AVUser logInWithUsernameInBackground:self.textFieldUserName.text password:self.textFieldPassword.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            //如果用户名和密码正确,提示登陆成功,跳转到我的页面
            UIAlertController *alertSure = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertSure addAction:actionSure];
            [self presentViewController:alertSure animated:YES completion:nil];
        } else {
            //否则提示登录失败,留在当前页面
            UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆失败,用户名或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionError = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertError addAction:actionError];
            [self presentViewController:alertError animated:YES completion:nil];
        }
    }];
    //回收键盘
    [self.view endEditing:YES];
}

//实现代理的设置
- (void)setDelegate{
    self.textFieldUserName.delegate = self;
    self.textFieldPassword.delegate = self;
    
}

#pragma mark - textField的代理方法
//点击return键回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

//实现点击空白回收键盘事件
- (void)tapAction{
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
