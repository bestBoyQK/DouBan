//
//  MovieListCollectionViewController.h
//  DouBan
//


#import "BaseViewController.h"
#import "MovieModel.h"


@interface MovieListCollectionViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)MovieModel *model;

@end
