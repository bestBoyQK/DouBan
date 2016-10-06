//
//  MovieDetailViewController.m
//  DouBan
//


#import "MovieDetailViewController.h"
#import "MovieDetailModel.h"
#import <UIImageView+WebCache.h>
#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UserDataBase.h"

@interface MovieDetailViewController ()

{
    MovieDetailModel *modelDetail;
}

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];//获得数据
    
    
}

#pragma mark 获取数据
- (void)getData{
    //将电影收藏页面传过来的movieid赋给movieid
    self.movieid = [NSString stringWithFormat:@"%@",self.detailModel.movieid];
    //判断电影收藏页面传过来的movieid是否为空
    if (self.detailModel == nil) {
        //如果为空将电影列表页面穿过来得movieid赋给movieid
        self.movieid = [NSString stringWithFormat:@"%@",self.model.movieId];
    }
    //根据传过来的movieId拼接获取数据的URL
    NSString *url = [SEARCHMOVIEURL stringByAppendingString:self.movieid];
    //将URL放到一个请求中
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    //建立session数据连接
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *dicResult = dic[@"result"];
            modelDetail = [[MovieDetailModel alloc] init];
            [modelDetail setValuesForKeysWithDictionary:dicResult];
            //回到主线程(解析完成后要对加载器和数据进行处理)
            [self performSelectorOnMainThread:@selector(mainAction) withObject:nil waitUntilDone:YES];
        }
        
    }];
    [task resume];
}

//实现解析完成后的方法
- (void)mainAction{
    //隐藏加载器
    [self.HUD hide:YES];
    //更新数据
    [self setAllViews];//设置所有视图
}



#pragma mark 设置所有视图
- (void)setAllViews{
    //设置标题
    self.title = modelDetail.title;
    //给UI控件赋值
    self.movieRating.text = [NSString stringWithFormat:@"评分:  %@",modelDetail.rating];
    self.movieRatingCount.text = [NSString stringWithFormat:@"(%@评论)",modelDetail.rating_count];
    self.movieReleaseDate.text = modelDetail.release_date;
    self.movieRunTime.text = modelDetail.runtime;
    self.movieGenres.text = modelDetail.genres;
    self.movieCountry.text = modelDetail.country;
    [self.movieImV sd_setImageWithURL:[NSURL URLWithString:modelDetail.poster]];
    self.movieActorsIfno.text = modelDetail.actors;
    self.moviePlotSimple.text = [NSString stringWithFormat:@"%@",modelDetail.plot_simple];
    //设置返回按钮点击事件
    UIBarButtonItem *movieBackItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(movieBackItemAction)];
    self.navigationItem.leftBarButtonItem = movieBackItem;
    movieBackItem.tintColor = [UIColor whiteColor];
    //设置收藏按钮
    UIBarButtonItem *movieShareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_share"] style:(UIBarButtonItemStylePlain) target:self action:@selector(movieShareItemAction)];
    self.navigationItem.rightBarButtonItem = movieShareItem;
    movieShareItem.tintColor = [UIColor whiteColor];
    
    
}

//实现返回按钮点击事件
- (void)movieBackItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//实现收藏按钮点击事件
- (void)movieShareItemAction{
    //判断当前用户是否已经登陆
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        //如果已存在允许用户使用应用
        //打开数据库
        [[UserDataBase shareUserDB] openUserDB];
        //创建数组接收查询到得数据
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[UserDataBase shareUserDB] selectAllMovies]];
        //用于判断当前数组中是否已存在要添加的数据
        BOOL ifCollect = YES;
        //遍历数组
        for (MovieDetailModel *mmodel in array) {
            //判断要添加的电影的ID是否已经在数据库中
            if ([mmodel.movieid isEqualToString:self.model.movieId]) {
                //如果已经存在就提示用户
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该电影已收藏" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                ifCollect = NO;
            }
            
        }
        //如果不存在就添加到数据库
        if (ifCollect){
            //将数据插入到数据库
            [[UserDataBase shareUserDB] insertMovie:modelDetail];
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
