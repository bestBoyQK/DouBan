//
//  CinemaTableViewCell.h
//  DouBan
//


#import "BaseTableViewCell.h"

@interface CinemaTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lableCinemaName;//影院名
@property (weak, nonatomic) IBOutlet UILabel *lableAddress;//影院地址
@property (weak, nonatomic) IBOutlet UILabel *lableTelephone;//影院电话

@end
