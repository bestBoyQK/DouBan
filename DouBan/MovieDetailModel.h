//
//  MovieDetailModel.h
//  DouBan
//


#import "BaseObject.h"

@interface MovieDetailModel : BaseObject

@property (nonatomic,strong)NSString *title;//电影名字
@property (nonatomic,strong)NSString *genres;//分类
@property (nonatomic,strong)NSString *country;//国家
@property (nonatomic,strong)NSString *runtime;//时间
@property (nonatomic,strong)NSString *poster;//图片
@property (nonatomic,strong)NSString *rating_count;//评论人数
@property (nonatomic,strong)NSString *rating;//评分
@property (nonatomic,strong)NSString *release_date;//上映时间
@property (nonatomic,strong)NSString *actors;//制作人信息
@property (nonatomic,strong)NSString *plot_simple;//简介
@property (nonatomic,strong)NSString *movieid;//电影ID
@end
