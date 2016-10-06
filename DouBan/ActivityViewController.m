//
//  ActivityViewController.m
//  DouBan
//


#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityModel.h"
#import <UIImageView+WebCache.h>
#import "ActivityDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *arrayAllData;
}

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化SDK
    //指定目标(告诉程序要修改哪个账号中的哪个工程里的数据)
    [AVOSCloud setApplicationId:@"9Cn2LG62jPOAJXnLOamN4XTC-gzGzoHsz"
                      clientKey:@"k4OTYsEK3Gsq507RWOTMERvS"];
    
    [self setTableView];//设置tableView
    [self setDelegate];//设置代理
    [self getData];//取数据
//    self.tabBarController.selectedIndex = 2;
    
    
}

//实现tableview的设置
- (void)setTableView{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 2;
}

//设置代理实现方法
- (void)setDelegate{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

#pragma mark - 获取数据
- (void)getData{
    //将URL放到一个请求中
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ACTIVITYLISTURL]];
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
   
    //建立session数据连接
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            arrayAllData = [NSMutableArray array];
            for (NSDictionary *dict in dic[@"events"]) {
                ActivityModel *model = [[ActivityModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                //将影院的Id单独取出来,以便将数据插入数据库时使用
                [model setValue:dict[@"owner"][@"id"] forKey:@"aid"];
                [arrayAllData addObject:model];
            }
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
    [self.tableView reloadData];
}

#pragma mark - tableView的代理方法

//返回有多少组
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//返回每组有多少个元素
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayAllData.count;
}

//返回每一个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //自定义cell
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id_activity" forIndexPath:indexPath];
    //取数据
    ActivityModel *model = arrayAllData[indexPath.section];
    //设置cell的背景图片
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_eventlistcell@2x"]];
    
    //用取到的数据给UI控件赋值
    cell.activityTitle.text = [NSString stringWithFormat:@"   %@",model.title];
    cell.activityTime.text = [NSString stringWithFormat:@"%@ -- %@",[model.begin_time substringWithRange:NSMakeRange(5, 11)],[model.end_time substringWithRange:NSMakeRange(5, 11)]];
    cell.activityAddress.text = model.address;
    cell.activityType.text = [NSString stringWithFormat:@"类型:  %@",model.category_name];
    cell.activityWisherCount.text = [NSString stringWithFormat:@"%@",model.wisher_count];
    cell.activityParticipantCount.text = [NSString stringWithFormat:@"%@",model.participant_count];
    cell.activityTimeImV.image = [UIImage imageNamed:@"icon_date@2x"];
    cell.activityAddressImV.image = [UIImage imageNamed:@"icon_spot@2x"];
    cell.activityTypeImV.image = [UIImage imageNamed:@"icon_catalog@2x"];
    [cell.activityImV sd_setImageWithURL:[NSURL URLWithString:model.image]];
    //设置cell边框样式
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    return cell;
    
}

//返回头视图的行高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//返回尾视图的行高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
//点击cell响应事件
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //取到目标控制器
    ActivityDetailViewController *activityDetailVC = segue.destinationViewController;
    //根据sender(也就是cell)找到是从哪个位置的cell跳转过去的
    ActivityTableViewCell *cell = (ActivityTableViewCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    //把值传过去
    activityDetailVC.model = arrayAllData[path.section];
}


@end
