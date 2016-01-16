
// Created by Sinisa Drpa, 2015.

#import "EZPTrackerList+Synchronous.h"
#import "EZPTracker+Synchronous.h"

@implementation EZPTrackerList (Synchronous)

- (EZPTrackerList *)next {
   self.filters = self.filters ? self.filters : [NSMutableDictionary dictionary];
   self.filters[@"before_id"] = [self.trackers lastObject].itemId;
   
   return [EZPTracker list:self.filters];
}

@end
