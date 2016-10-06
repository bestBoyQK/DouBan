//
//  MyActivityViewController.m
//  DouBan
//


#import "MyActivityViewController.h"
#import "UserDataBase.h"
#import "ActivityModel.h"
#import "ActivityDetailViewController.h"

@interface MyActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayAllActivities;
    UITableViewCellEditingStyle style;
}
@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.HUD hide:YES];//隐藏加载器
   
    [self setDelegate];//设置代理
    [self getData];//从数据库取数据
    
    //设置删除按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"删除";

}

//实现设置代理
- (void)setDelegate{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

//取数据
- (void)getData{
    [[UserDataBase shareUserDB] openUserDB];
    arrayAllActivities = [NSMutableArray array];
    arrayAllActivities = [[UserDataBase shareUserDB] selectAllActivities];
    [[UserDataBase shareUserDB] closeUserDB];
}

#pragma mark - tableView代理方法
//返回有多行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayAllActivities.count;
}

//返回每个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id_myActivity" forIndexPath:indexPath];
    //将从数据库中取出的数据赋给model
    ActivityModel *model = arrayAllActivities[indexPath.row];
    //给UI控件赋值
    cell.textLabel.text = model.title;
    return cell;
}


//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到活动详情页面
    ActivityDetailViewController *activityDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"activityDetail"];
    //将数据传过去
    activityDetailVC.model = arrayAllActivities[indexPath.row];
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}

#pragma mark - 关于tableView的编辑
//自带的一个BarButtonItem点击事件
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    style = UITableViewCellEditingStyleDelete;
    //编辑tableView的第一步:让tableView处于编辑状态
    [self.tableView setEditing:editing animated:animated];
    self.editButtonItem.title = editing ? @"完成" : @"删除";
    
}

//提交编辑结果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //将要删除的数据赋给model
    ActivityModel *model = arrayAllActivities[indexPath.row];
    //删除数据
    [arrayAllActivities removeObjectAtIndex:indexPath.row];
    NSLog(@"qqqq%ld",indexPath.row);
    //删除UI
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
    //删除数据库中的数据
    //删除数据库中的数据
    [[UserDataBase shareUserDB] openUserDB];
    [[UserDataBase shareUserDB] deleteActivityByTitle:model];
    [[UserDataBase shareUserDB] closeUserDB];

    
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return style;
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
