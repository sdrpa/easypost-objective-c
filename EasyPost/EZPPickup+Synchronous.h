
// Created by Sinisa Drpa, 2015.

#import "EZPPickup.h"

@interface EZPPickup (Synchronous)

+ (EZPPickup *)retrieve:(NSString *)itemId;
+ (EZPPickup *)create:(NSDictionary *)parameters;
- (void)create;
- (void)buyWithCarrier:(NSString *)carrier service:(NSString *)service;
- (void)cancel;

@end
