
// Created by Sinisa Drpa, 2015.

#import "EZPAddress.h"

@interface EZPAddress (Synchronous)

+ (EZPAddress *)retrieve:(NSString *)addressId;
+ (EZPAddress *)create:(NSDictionary *)parameters;
- (void)create;
+ (EZPAddress *)createAndVerify:(NSDictionary *)parameters;
- (void)verify:(NSString *)carrier;

@end
