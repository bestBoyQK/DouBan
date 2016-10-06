//
//  MovieModel.h
//  DouBan
//


#import "BaseObject.h"

@interface MovieModel : BaseObject

@property (nonatomic,strong)NSString *movieId;//电影ID
@property (nonatomic,strong)NSString *movieName;//电影名
@property (nonatomic,strong)NSString *pic_url;//电影图片

@end
