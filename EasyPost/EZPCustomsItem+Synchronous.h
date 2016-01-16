
// Created by Sinisa Drpa, 2015.

#import "EZPCustomsItem.h"

@interface EZPCustomsItem (Synchronous)

+ (EZPCustomsItem *)retrieve:(NSString *)itemId;
+ (EZPCustomsItem *)create:(NSDictionary *)parameters;

@end
