
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPShipment;

@interface EZPShipmentList : EZPObject

@property (strong) NSArray<EZPShipment *> *shipments;
@property (assign) BOOL has_more;

@property (strong) NSMutableDictionary *filters;

@end
