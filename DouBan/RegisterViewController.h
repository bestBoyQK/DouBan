//
//  RegisterViewController.h
//  DouBan
//


#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;//用户名
@property (weak, nonatomic) IBOutlet UITextField *password;//密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;//确认密码
@property (weak, nonatomic) IBOutlet UITextField *email;//邮箱
@property (weak, nonatomic) IBOutlet UITextField *telNumber;//电话

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
