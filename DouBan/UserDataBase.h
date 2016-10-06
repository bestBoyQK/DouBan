//
//  UserDataBase.h
//  DouBan
//


#import "BaseObject.h"
#import <sqlite3.h>
#import <AVOSCloud/AVOSCloud.h>
#import "ActivityModel.h"
#import "MovieDetailModel.h"

@interface UserDataBase : BaseObject

+ (instancetype)shareUserDB;

//用于取当前用户的用户名
@property (nonatomic,strong)AVUser *currentUser;

//打开数据库
- (void)openUserDB;

//关闭数据库
- (void)closeUserDB;

//添加数据
//收藏活动
- (void)insertActivity:(ActivityModel *)activityModel;
//收藏电影
- (void)insertMovie:(MovieDetailModel *)movieModel;

//查询数据
//查询活动
- (NSMutableArray *)selectAllActivities;

//查询电影
//查找数据
- (NSMutableArray *)selectAllMovies;


//删除数据
//删除电影
- (void)deleteMoviebyTitle:(MovieDetailModel *)movieModel;

//删除活动
- (void)deleteActivityByTitle:(ActivityModel *)activityModel;

@end
