//
//  CinemaModel.m
//  DouBan
//


#import "CinemaModel.h"

@implementation CinemaModel



- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@",self.cinemaName,self.telephone,self.address];
}

@end
