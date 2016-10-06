//
//  MovieModel.m
//  DouBan
//


#import "MovieModel.h"

@implementation MovieModel

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@",self.movieId,self.movieName,self.pic_url];
}

@end
