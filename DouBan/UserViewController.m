//
//  UserViewController.m
//  DouBan
//


#import "UserViewController.h"
#import "UserTableViewCell.h"
#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UserDataBase.h"
#import "MyActivityViewController.h"
#import "MyMovieViewController.h"
#import <UIImageView+WebCache.h>

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>

{
       UIBarButtonItem *loginBarButtonItem;
}

@end

@implementation UserViewController

//根据当前用户的登录状态来设置登录按钮的状态
- (void)viewWillAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        loginBarButtonItem.title = @"注销";
    }else{
        loginBarButtonItem.title = @"登录";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegate];//设置代理
    [self.HUD hide:YES];//隐藏加载器
    [self setLoginBarButtonItem];//设置登录按钮
    
    
}

//实现设置代理
- (void)setDelegate{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - tableView的代理方法

//返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

//返回每个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自定义cell
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id_user" forIndexPath:indexPath];
    //分行显示cell的内容
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的活动";
    } else if(indexPath.row == 1){
        cell.textLabel.text = @"我的电影";
    }else{
        cell.textLabel.text = @"清除缓存";
    }
    return cell;
}

//cell点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        //如果是允许用户使用应用
        //判断用户所点击的事件
        if (indexPath.row == 0) {
            MyActivityViewController *myActivityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myAcitvity_id"];
            //跳转到活动收藏列表
            [self.navigationController pushViewController:myActivityVC animated:YES];
        }else if(indexPath.row == 1){
            MyMovieViewController *myMovieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myMovie_id"];
            //跳转到电影收藏列表
            [self.navigationController pushViewController:myMovieVC animated:YES];
        }else{
            //提示是否要清除缓存
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要清除缓存吗?" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //清除缓存(用SDWebImage的方法,只清除沙盒Cache文件夹里的图片,音频,视频)
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
               
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
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

#pragma mark - 登陆按钮的设置
- (void)setLoginBarButtonItem{
    loginBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = loginBarButtonItem;
    
}

//登录按钮响应事件
- (void)loginBarButtonItemAction:(UIBarButtonItem *)sender{
    //判断当前按钮的状态(如果为登陆则跳转)
    if ([loginBarButtonItem.title isEqualToString:@"登录"]) {
       [self performSegueWithIdentifier:@"login" sender:sender];
    }else{
        //提示是否要注销
        UIAlertController *alertSure = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要注销吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            sender.title = @"登录";
            //注销的同时清除用户缓存
            [AVUser logOut];
            NSLog(@"清除缓存用户对象成功");
        }];
        [alertSure addAction:actionSure];

        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertSure addAction:actionCancel];
        
        [self presentViewController:alertSure animated:YES completion:nil];

    }
}

/*
//取消某一个tableViewCell的点击事件
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 2) {
//        return nil;
//    }else{
//        return indexPath;
//    }
//}
*/

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
