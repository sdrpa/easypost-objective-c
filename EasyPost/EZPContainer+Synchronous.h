
// Created by Sinisa Drpa, 2015.

#import "EZPContainer.h"

@interface EZPContainer (Synchronous)

+ (EZPContainer *)retrieve:(NSString *)itemId;
+ (EZPContainer *)create:(NSDictionary *)parameters;

@end
