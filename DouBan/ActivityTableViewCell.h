//
//  ActivityTableViewCell.h
//  DouBan
//


#import "BaseTableViewCell.h"

@interface ActivityTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityTitle;//活动标题
@property (weak, nonatomic) IBOutlet UILabel *activityTime;//活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;//活动地址
@property (weak, nonatomic) IBOutlet UILabel *activityType;//活动类型
@property (weak, nonatomic) IBOutlet UILabel *activityWisherCount;//感兴趣人数
@property (weak, nonatomic) IBOutlet UILabel *activityParticipantCount;//参加人数

@property (weak, nonatomic) IBOutlet UIImageView *activityTimeImV;//活动时间图标
@property (weak, nonatomic) IBOutlet UIImageView *activityAddressImV;//活动地址图标
@property (weak, nonatomic) IBOutlet UIImageView *activityTypeImV;//活动类型图标
@property (weak, nonatomic) IBOutlet UIImageView *activityImV;//活动图片

@end
