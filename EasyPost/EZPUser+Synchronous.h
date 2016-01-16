
// Created by Sinisa Drpa, 2015.

#import "EZPUser.h"

@interface EZPUser (Synchronous)

+ (EZPUser *)retrieve:(NSString *)itemId;
+ (NSArray *)retrieveUsers;
+ (EZPUser *)create:(NSDictionary *)parameters;
- (void)update:(NSDictionary *)parameters;

@end
