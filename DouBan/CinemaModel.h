//
//  CinemaModel.h
//  DouBan
//


#import "BaseObject.h"

@interface CinemaModel : BaseObject

@property (nonatomic,strong)NSString *cinemaName;//影院名
@property (nonatomic,strong)NSString *telephone;//影院电话
@property (nonatomic,strong)NSString *address;//影院地址
@property (nonatomic,strong)NSString *trafficRoutes;//影院路线

@end
