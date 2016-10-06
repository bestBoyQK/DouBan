//
//  MovieTableViewCell.h
//  DouBan
//


#import "BaseTableViewCell.h"

@interface MovieTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imV;//电影图片
@property (weak, nonatomic) IBOutlet UILabel *lable;//电影名

@end
