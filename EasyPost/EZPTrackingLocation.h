
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPTrackingLocation : EZPObject

@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *city;
@property (copy) NSString *state;
@property (copy) NSString *country;
@property (copy) NSString *zip;

@end
