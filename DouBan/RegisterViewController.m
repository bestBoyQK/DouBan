//
//  RegisterViewController.m
//  DouBan
//


#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.HUD hide:YES];//隐藏加载器
    [self setDelegate];//设置代理
    //点击空白实现回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

//设置代理实现方法
- (void)setDelegate{
    self.userName.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    self.email.delegate = self;
    self.telNumber.delegate = self;
}

#pragma mark - textField的代理方法
//点击return键回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

//实现scrollView上移
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag != 101 && textField.tag != 102) {
        self.scrollView.contentOffset = CGPointMake(0, textField.tag - 100);
    }
}


//实现点击空白回收键盘事件
- (void)tapAction{
    [self.view endEditing:YES];
}

#pragma mark - 实现注册按钮点击事件
- (IBAction)registerBarButtonItemAction:(id)sender {
    //判断用户名和密码是否为空
    AVUser *user = [AVUser user];
    user.username = self.userName.text;
    user.password = self.password.text;
    //判断两次密码是否一致如果一致执行下面方法
    if ([self.password.text isEqualToString:self.confirmPassword.text]) {
        
        //当设置用户邮箱时,LeanCloud会自动给此邮箱发送验证邮件
        //当设置用户电话号码(mobilePhoneNumber属性)时,LeanCloud会自动发送验证短信(一天免费5条,多余收费).验证成功后，用户的 mobilePhoneVerified 属性变为 true，并会触发调用云代码的 AV.Cloud.onVerifed('sms', function) 方法。
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //如果不为空提示注册成功,跳转到登陆页面
                UIAlertController *alertSure = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertSure addAction:actionSure];
                [self presentViewController:alertSure animated:YES completion:nil];
                
            }else{
                //否则提示注册失败,留在当前页面
                UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册失败,用户名和密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionError = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertError addAction:actionError];
                [self presentViewController:alertError animated:YES completion:nil];
                
            }
        }];
        //否则提示,留在当前页面
        }else if([self.password.text isEqualToString:self.confirmPassword.text] == NO){
            UIAlertController *alertError= [UIAlertController alertControllerWithTitle:@"提示" message:@"注册失败,两次密码不一致" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionError = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertError addAction:actionError];
            [self presentViewController:alertError animated:YES completion:nil];
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
