
// Created by Sinisa Drpa, 2015.

#import "EZPParcel.h"

@interface EZPParcel (Synchronous)

+ (EZPParcel *)retrieve:(NSString *)itemId;
+ (NSArray *)retrieve;
+ (EZPParcel *)create:(NSDictionary *)parameters;

@end
