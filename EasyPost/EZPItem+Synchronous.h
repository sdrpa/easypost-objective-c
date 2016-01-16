
// Created by Sinisa Drpa, 2015.

#import "EZPItem.h"

@interface EZPItem (Synchronous)

+ (EZPItem *)retrieve:(NSString *)itemId;
+ (EZPItem *)create:(NSDictionary *)parameters;
+ (EZPItem *)retrieve:(NSString *)name value:(NSString *)value;

@end
