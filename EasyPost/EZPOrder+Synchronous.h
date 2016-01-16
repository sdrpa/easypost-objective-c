
// Created by Sinisa Drpa, 2015.

#import "EZPOrder.h"

@class EZPRate;

@interface EZPOrder (Synchronous)

+ (EZPOrder *)retrieve:(NSString *)itemId;
+ (EZPOrder *)create:(NSDictionary *)parameters;
- (void)create;
- (void)buyWithRate:(EZPRate *)rate;
- (void)buy:(NSString *)carrier service:(NSString *)service;

@end
