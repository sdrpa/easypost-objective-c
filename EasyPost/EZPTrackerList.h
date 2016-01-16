
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPTracker;

@interface EZPTrackerList : EZPObject

@property (strong) NSArray<EZPTracker *> *trackers;
@property (assign) BOOL has_more;

@property (strong) NSMutableDictionary *filters;

@end
