//
//  MovieViewController.m
//  DouBan
//


#import "MovieViewController.h"
#import "MovieModel.h"
#import "MovieTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MovieListCollectionViewController.h"

@interface MovieViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *arrayAllData;
    MovieModel *model;
}

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];//设置tableView
    [self setDelegate];//设置代理
    [self getData];//取数据
    
    
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MOVIEURL]];
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    //建立session数据连接
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            arrayAllData = [NSMutableArray array];
            for (NSDictionary *dict in dic[@"result"]) {
                model = [[MovieModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
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

//返回每组的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayAllData.count;
}

//返回每一个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自定义cell
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id_movie" forIndexPath:indexPath];
    //取值
    model = arrayAllData[indexPath.section];
    //设置cell的背景图片
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_eventlistcell@2x"]];
    //给UI控件赋值
    cell.lable.text = model.movieName;
    [cell.imV sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    //设置cell的边框样式
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


//- (IBAction)movieListCollection:(id)sender {
//    MovieListCollectionViewController *moiveListCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieListCollection"];
//    moiveListCVC.model = model;
//    [self.navigationController pushViewController:moiveListCVC animated:YES];
//}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//实现cell点击事件
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //判断当前标示是否为详情标示
    if ([segue.identifier isEqualToString:@"detail"]) {
        //取到目标控制器
        id movieDetailVC = segue.destinationViewController;
        //根据sender(也就是cell)找到是从哪个位置的cell跳转过去的
        MovieTableViewCell *cell = (MovieTableViewCell *)sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        //用KVC的方式把值传过去
        [movieDetailVC setValue:arrayAllData[path.section] forKey:@"model"];
    }
   
}


@end
