//
//  UserDataBase.m
//  DouBan
//


#import "UserDataBase.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation UserDataBase

+ (instancetype)shareUserDB
{
    static UserDataBase *userDataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDataBase = [[UserDataBase alloc]init];
    });
    return userDataBase;
}

//创建数据库对象
static sqlite3 *userdb = nil;

//打开数据库
- (void)openUserDB{
    if (userdb == nil) {
        self.currentUser = [AVUser currentUser];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UserDataBase.sqlite"];
        NSLog(@"%@",filePath);
        
        //打开数据库
        int result = sqlite3_open(filePath.UTF8String, &userdb);
        NSLog(@"打开数据库成功");
        //创建表
        if (result == SQLITE_OK) {
            //创建活动收藏表
            NSString *sql = [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS activity%@ (aid TEXT PRIMARY KEY  NOT NULL , title TEXT, beginTime TEXT, endTime TEXT,address TEXT,categoryName TEXT,participantCount TEXT,wisherCount TEXT,image TEXT,content TEXT,activityOwnerName TEXT)",self.currentUser.username];
            //创建电影收藏表
            NSString *sql1 = [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS movie%@ (movieId TEXT PRIMARY KEY  NOT NULL , title TEXT, genres TEXT, country TEXT,runtime TEXT,poster TEXT,ratingCount TEXT,rating TEXT,releaseDate TEXT,actors TEXT,plotSimple TEXT)",self.currentUser.username];
            //执行sql语句
            int result1 = sqlite3_exec(userdb, sql.UTF8String, NULL, NULL, NULL);
            int result2 = sqlite3_exec(userdb, sql1.UTF8String, NULL, NULL, NULL);
            if (result1 == SQLITE_OK && result2 == SQLITE_OK) {
                NSLog(@"创建表格成功");
            }else{
                NSLog(@"创建表格失败");
            }

        }
    
    }else{
        NSLog(@"打开数据库失败");
    }

}


//收藏活动
- (void)insertActivity:(ActivityModel *)activityModel{
    self.currentUser = [AVUser currentUser];
    //把传过来的数据格式化放到sql语句中区
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO activity%@ (aid,title,beginTime,endTime,address,categoryName,participantCount,wisherCount,image,content) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.currentUser.username,
                     activityModel.aid,
                     activityModel.title,
                     activityModel.begin_time,
                     activityModel.end_time,
                     activityModel.address,
                     activityModel.category_name,
                     activityModel.participant_count,
                     activityModel.wisher_count,
                     activityModel.image,
                     activityModel.content];
    //执行sql语句
    int result = sqlite3_exec(userdb, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else{
        NSLog(@"添加数据失败");
        
    }
    

}

//查询活动
- (NSMutableArray *)selectAllActivities{
    self.currentUser = [AVUser currentUser];
    NSMutableArray *arrayAllActivities = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM activity%@",self.currentUser.username];
    sqlite3_stmt *stmt = nil;
    //第三个参数-1,自动计算长度
    //第四个参数:游标
    int result = sqlite3_prepare_v2(userdb, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"开始查询");
        //开始查找数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //拿到id的值
            char *aid1 = (char *)sqlite3_column_text(stmt, 0);
            NSString *aid = [NSString stringWithCString:aid1 encoding:NSUTF8StringEncoding];
            //拿到title的值
            char *title1 = (char *)sqlite3_column_text(stmt, 1);
            NSString *title = [NSString stringWithCString:title1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *beginTime1 = (char *)sqlite3_column_text(stmt, 2);
            NSString *beginTime = [NSString stringWithCString:beginTime1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *endTime1 = (char *)sqlite3_column_text(stmt, 3);
            NSString *endTime = [NSString stringWithCString:endTime1 encoding:NSUTF8StringEncoding];
            //拿到endTime的值
            char *address1 = (char *)sqlite3_column_text(stmt, 4);
            NSString *address = [NSString stringWithCString:address1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *categoryName1 = (char *)sqlite3_column_text(stmt, 5);
            NSString *categoryName = [NSString stringWithCString:categoryName1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *participantCount1 = (char *)sqlite3_column_text(stmt, 6);
            NSString *participantCount = [NSString stringWithCString:participantCount1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *wisher_count1 = (char *)sqlite3_column_text(stmt, 7);
            NSString *wisher_count = [NSString stringWithCString:wisher_count1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *image1 = (char *)sqlite3_column_text(stmt, 8);
            NSString *image = [NSString stringWithCString:image1 encoding:NSUTF8StringEncoding];
            //拿到beginTime的值
            char *content1 = (char *)sqlite3_column_text(stmt, 9);
            NSString *content = [NSString stringWithCString:content1 encoding:NSUTF8StringEncoding];
            ActivityModel *model = [[ActivityModel alloc] init];
            model.aid = aid;
            model.title = title;
            model.begin_time = beginTime;
            model.end_time = endTime;
            model.address = address;
            model.category_name = categoryName;
            model.participant_count = participantCount;
            model.wisher_count = wisher_count;
            model.image = image;
            model.content = content;
            [arrayAllActivities addObject:model];
        }
    } else {
        NSLog(@"查询失败");
    }
    //释放游标
    sqlite3_finalize(stmt);
    return arrayAllActivities;
    

}


//收藏电影
- (void)insertMovie:(MovieDetailModel *)movieModel{
    self.currentUser = [AVUser currentUser];
    //把传过来的数据格式化放到sql语句中区
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO movie%@ (movieId, title) VALUES ('%@','%@')",self.currentUser.username,
                     movieModel.movieid,
                     movieModel.title];
/*
//    NSString *sql = [NSString stringWithFormat:@"INSERT INTO movie%@ (movieId, title, genres, country,runtime,poster,ratingCount,rating,releaseDate,actors ,plotSimple) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.currentUser.username,
//                     movieModel.movieid,
//                     movieModel.title,
//                     movieModel.genres,
//                     movieModel.country,
//                     movieModel.runtime,
//                     movieModel.poster,
//                     movieModel.rating_count,
//                     movieModel.rating,
//                     movieModel.release_date,
//                     movieModel.actors,
//                     movieModel.plot_simple];
 */
    //执行sql语句
    int result = sqlite3_exec(userdb, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else{
        NSLog(@"添加数据失败");
        
    }
    

}


//查询电影
- (NSMutableArray *)selectAllMovies{
    self.currentUser = [AVUser currentUser];
    NSMutableArray *arrayAllmovies = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM movie%@",self.currentUser.username];
    sqlite3_stmt *stmt = nil;
    //第三个参数-1,自动计算长度
    //第四个参数:游标
    int result = sqlite3_prepare_v2(userdb, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"开始查询");
        //开始查找数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //拿到id的值
            char *movieId1 = (char *)sqlite3_column_text(stmt, 0);
            NSString *movieId = [NSString stringWithCString:movieId1 encoding:NSUTF8StringEncoding];
            //拿到title的值
            char *title1 = (char *)sqlite3_column_text(stmt, 1);
            NSString *title = [NSString stringWithCString:title1 encoding:NSUTF8StringEncoding];
            /*
            //拿到genres的值
//            char *genres1 = (char *)sqlite3_column_text(stmt, 2);
//            NSString *genres = [NSString stringWithCString:genres1 encoding:NSUTF8StringEncoding];
//            //拿到country的值
//            char *country1 = (char *)sqlite3_column_text(stmt, 3);
//            NSString *country = [NSString stringWithCString:country1 encoding:NSUTF8StringEncoding];
//            //拿到runtime的值
//            char *runtime1 = (char *)sqlite3_column_text(stmt, 4);
//            NSString *runtime = [NSString stringWithCString:runtime1 encoding:NSUTF8StringEncoding];
//            //拿到poster的值
//            char *poster1 = (char *)sqlite3_column_text(stmt, 5);
//            NSString *poster = [NSString stringWithCString:poster1 encoding:NSUTF8StringEncoding];
//            //拿到ratingCount的值
//            char *ratingCount1 = (char *)sqlite3_column_text(stmt, 6);
//            NSString *ratingCount = [NSString stringWithCString:ratingCount1 encoding:NSUTF8StringEncoding];
//            //拿到rating的值
//            char *rating1 = (char *)sqlite3_column_text(stmt, 7);
//            NSString *rating = [NSString stringWithCString:rating1 encoding:NSUTF8StringEncoding];
//            //拿到releaseDate的值
//            char *releaseDate1 = (char *)sqlite3_column_text(stmt, 8);
//            NSString *releaseDate = [NSString stringWithCString:releaseDate1 encoding:NSUTF8StringEncoding];
//            //拿到actors的值
//            char *actors1 = (char *)sqlite3_column_text(stmt, 9);
//            NSString *actors = [NSString stringWithCString:actors1 encoding:NSUTF8StringEncoding];
//            //拿到plotSimple的值
//            char *plotSimple1 = (char *)sqlite3_column_text(stmt, 9);
//            NSString *plotSimple = [NSString stringWithCString:plotSimple1 encoding:NSUTF8StringEncoding];
             */
            MovieDetailModel *model = [[MovieDetailModel alloc] init];
            model.movieid = movieId;
            model.title = title;
            /*
//            model.genres = genres;
//            model.country = country;
//            model.runtime = runtime;
//            model.poster = poster;
//            model.rating_count = ratingCount;
//            model.rating = rating;
//            model.release_date = releaseDate;
//            model.actors = actors;
//            model.plot_simple = plotSimple;
            */
            [arrayAllmovies addObject:model];
        }
    } else {
        NSLog(@"查询失败");
    }
    //释放游标
    sqlite3_finalize(stmt);
    return arrayAllmovies;

}

//根据电影的title删除电影
- (void)deleteMoviebyTitle:(MovieDetailModel *)movieModel{
    self.currentUser = [AVUser currentUser];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM movie%@ WHERE title = '%@' ",self.currentUser.username,movieModel.title];
    //执行sql语句
    int result = sqlite3_exec(userdb, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
        
    }

}

//根据活动的title删除活动
- (void)deleteActivityByTitle:(ActivityModel *)activityModel{
    self.currentUser = [AVUser currentUser];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM activity%@ WHERE title = '%@' ",self.currentUser.username,activityModel.title];
    NSLog(@"%@",activityModel.title);
    //执行sql语句
    int result = sqlite3_exec(userdb, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
        
    }
 
}



//关闭数据库
- (void)closeUserDB{
    if (userdb != nil) {
        int result = sqlite3_close(userdb);
        if (result == SQLITE_OK) {
            NSLog(@"关闭数据库成功");
            userdb = nil;
        } else {
            NSLog(@"关闭数据库失败");
        }
    }
}

@end
