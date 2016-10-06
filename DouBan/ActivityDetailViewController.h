//
//  ActivityDetailViewController.h
//  DouBan
//


#import "BaseViewController.h"
#import "ActivityModel.h"

@interface ActivityDetailViewController : BaseViewController

@property (nonatomic,strong)ActivityModel *model;//接收活动列表页面传过来的数据
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;//活动标题
@property (weak, nonatomic) IBOutlet UILabel *activityTime;//活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityOwnerName;//活动举办方姓名
@property (weak, nonatomic) IBOutlet UILabel *activityType;//活动类型
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;//活动地址
@property (weak, nonatomic) IBOutlet UILabel *activityContent;//活动内容

@property (weak, nonatomic) IBOutlet UIImageView *activityImV;//活动图片

@end
