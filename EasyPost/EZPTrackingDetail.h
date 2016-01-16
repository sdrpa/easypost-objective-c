
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPTrackingLocation;

@interface EZPTrackingDetail : EZPObject

@property (strong) NSDate *datetime;
@property (copy) NSString *message;
@property (copy) NSString *status;
@property (strong) EZPTrackingLocation *tracking_location;

@end
