//
//  ActivityDetailViewController.m
//  DouBan
//


#import "ActivityDetailViewController.h"
#import <UIImageView+WebCache.h>
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "UserDataBase.h"
#import "ActivityModel.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllViews];//设置所有视图
    [self.HUD hide:YES];//隐藏加载器
    
}


//实现所有视图的设置
- (void)setAllViews{
    //设置标题
    self.title = self.model.title;
    //给UI控件赋值
    self.activityTitle.text = self.model.title;
    self.activityTime.text = [NSString stringWithFormat:@"%@ -- %@",[self.model.begin_time substringWithRange:NSMakeRange(5, 11)],[self.model.end_time substringWithRange:NSMakeRange(5, 11)]];
    self.activityType.text = [NSString stringWithFormat:@"类型:  %@",self.model.category_name];
    self.activityAddress.text = self.model.address;
    [self.activityImV sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
    self.activityContent.text = self.model.content;
    self.activityOwnerName.text = self.model.owner[@"name"];
    //设置返回按钮点击事件
    UIBarButtonItem *activityBackItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(activityBackItemAction)];
    self.navigationItem.leftBarButtonItem = activityBackItem;
    activityBackItem.tintColor = [UIColor whiteColor];
    //设置收藏按钮
    UIBarButtonItem *activityShareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_share"] style:(UIBarButtonItemStylePlain) target:self action:@selector(activityShareItemAction)];
    self.navigationItem.rightBarButtonItem = activityShareItem;
    activityShareItem.tintColor = [UIColor whiteColor];
    
    
}

//实现返回按钮点击事件
- (void)activityBackItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//实现收藏按钮点击事件
- (void)activityShareItemAction{
    //判断当前用户是否已经登陆
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        //如果是允许用户使用应用
        //打开数据库
        [[UserDataBase shareUserDB] openUserDB];
        //创建数组用来接收查询数据
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[UserDataBase shareUserDB] selectAllActivities]];
       //用于判断要添加的信息是否已经存在
        BOOL ifCollect = YES;
        //遍历数组
        for (ActivityModel *amodel in array) {
            //如果已存在则提示用户
            if ([amodel.aid isEqualToString:self.model.aid]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该活动已收藏" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                ifCollect = NO;
            }
            
        }
            //如果不存在就添加
            if (ifCollect){
                //将数据插入到数据库
                [[UserDataBase shareUserDB] insertActivity:self.model];
                //提示用户收藏成功
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
                
                [self presentViewController:alert animated:YES completion:^{
                    sleep(2);
                }];
                [self dismissViewControllerAnimated:YES completion:nil];

            }
            //关闭数据库
            [[UserDataBase shareUserDB] closeUserDB];

        
    } else {
        //否则跳转到登陆界面
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login_id"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
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
