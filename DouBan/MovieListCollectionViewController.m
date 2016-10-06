//
//  MovieListCollectionViewController.m
//  DouBan
//

#import "MovieListCollectionViewController.h"
#import <UIImageView+WebCache.h>
#import "MovieModel.h"
#import "MovieListCollectionViewCell.h"
#import "MovieDetailViewController.h"


@interface MovieListCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
//    NSInteger count;
    NSMutableArray *arrayAllData;
}


@end

@implementation MovieListCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarButtonItem];//设置item
    [self getData];//获取数据
    //设置collectionView的背景
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}



#pragma mark - Item设置
//设置item实现方法
- (void)setBarButtonItem{
    //设置空白的按钮代替系统左边的按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    //设置右边图片按钮的点击事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_list@2x"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemAction)];
    //设置颜色
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
  
}

//实现右边图片按钮的点击事件
- (void)rightBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
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
                MovieModel *model = [[MovieModel alloc] init];
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
//    [self setMovieListCollection];//设置图片集合
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

#pragma mark - collectionView的代理方法
//返回cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return arrayAllData.count;
}

//返回每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_movieCollection" forIndexPath:indexPath];
    MovieModel *model = arrayAllData[indexPath.row];
    [cell.imV sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    cell.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.label.text = model.movieName;
  
    return cell;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到电影详情页面
    MovieDetailViewController *movieDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetail"];
    //把数据传过去
    movieDetailVC.model = arrayAllData[indexPath.row];
//    [self presentViewController:movieDetailVC animated:YES completion:nil];
    [self.navigationController pushViewController:movieDetailVC animated:YES];
}




/*
#pragma mark - MovieListCollection的设置

//- (void)setMovieListCollection{
//    
////    count = 0;
//    //循环设置图片
//    for (int i = 0; i < 9; i++) {
//        for (int j = 0; j < 3; j++) {
//            if (3 * i + j + 1 < arrayAllData.count) {
//                
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * j + 10, (kScreenWidth / 3 + 60) * i + 5 ,kScreenWidth / 3 - 20 ,  kScreenWidth / 3 + 20)];
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * j + 10, CGRectGetMaxY(imageView.frame) + 10 ,kScreenWidth / 3 - 20 ,  20)];
//                label.font = [UIFont systemFontOfSize:15];
//                label.lineBreakMode = NSLineBreakByTruncatingMiddle;
//                label.textAlignment = NSTextAlignmentCenter;
//                MovieModel *model = arrayAllData[3 * i  + (j + 1)];
//                imageView.backgroundColor = [UIColor lightGrayColor];
//                [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
//                label.text = model.movieName;
//                [self.movieListCollectionV.scroll addSubview:imageView];
//                [self.movieListCollectionV.scroll addSubview:label];
//                imageView.userInteractionEnabled = YES;
//            }
//            
//            //            //缩略图点击事件
//            //            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//            //            [imageView addGestureRecognizer:tap];
//            //
//            //            imageView.tag = 101 + (count++);
//            
//        }
//        
//    }
//
//    
//    
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
