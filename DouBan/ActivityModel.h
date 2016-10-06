//
//  ActivityModel.h
//  DouBan
//


#import "BaseObject.h"
#import <UIKit/UIKit.h>

@interface ActivityModel : BaseObject

@property(nonatomic,strong)NSString *title;//活动标题
@property(nonatomic,strong)NSString *begin_time;//开始时间
@property(nonatomic,strong)NSString *end_time;//结束时间
@property(nonatomic,strong)NSString *address;//活动地址
@property(nonatomic,strong)NSString *category_name;//活动类型
@property(nonatomic,strong)NSString *participant_count;//参加人数
@property(nonatomic,strong)NSString *wisher_count;//感兴趣人数
@property(nonatomic,strong)NSString *image;//活动图像
@property (nonatomic,strong)NSString *content;//活动内容
@property (nonatomic,strong)NSDictionary *owner;//活动举办方
@property (nonatomic,strong)NSString *aid;//活动ID
@end
