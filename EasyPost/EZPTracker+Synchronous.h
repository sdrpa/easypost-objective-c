
// Created by Sinisa Drpa, 2015.

#import "EZPTracker.h"

@class EZPTrackerList;

@interface EZPTracker (Synchronous)

+ (EZPTrackerList *)list:(NSDictionary *)parameters;
+ (EZPTracker *)create:(NSString *)carrier trackingCode:(NSString *)trackingCode;
+ (EZPTracker *)retrieve:(NSString *)itemId;

@end
