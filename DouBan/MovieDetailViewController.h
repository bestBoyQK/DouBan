//
//  MovieDetailViewController.h
//  DouBan
//


#import "BaseViewController.h"
#import "MovieModel.h"
#import "MovieDetailModel.h"

@interface MovieDetailViewController : BaseViewController

@property (nonatomic,strong)MovieModel *model;//接收电影列表页面传过来的数据
@property (nonatomic,strong)NSString *movieid;//用于存储接收到的movieid
@property (weak, nonatomic) IBOutlet UIImageView *movieImV;//电影图片
@property (weak, nonatomic) IBOutlet UILabel *movieRating;//评分
@property (weak, nonatomic) IBOutlet UILabel *movieRatingCount;//评论人数

@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDate;//上映日期
@property (weak, nonatomic) IBOutlet UILabel *movieRunTime;//时间
@property (weak, nonatomic) IBOutlet UILabel *movieGenres;//类型
@property (weak, nonatomic) IBOutlet UILabel *movieCountry;//国家
@property (weak, nonatomic) IBOutlet UILabel *movieActorsIfno;//制作人信息
@property (weak, nonatomic) IBOutlet UILabel *moviePlotSimple;//简介
@property (nonatomic,strong)MovieDetailModel *detailModel;//接收电影收藏页面传过来的movieid
@end
