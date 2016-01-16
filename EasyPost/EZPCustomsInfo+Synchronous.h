
// Created by Sinisa Drpa, 2015.

#import "EZPCustomsInfo.h"

@interface EZPCustomsInfo (Synchronous)

+ (EZPCustomsInfo *)retrieve:(NSString *)itemId;
+ (EZPCustomsInfo *)create:(NSDictionary *)parameters;

@end
