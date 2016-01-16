
// Created by Sinisa Drpa, 2015.

#import "EZPShipmentList+Synchronous.h"
#import "EZPShipment+Synchronous.h"

@implementation EZPShipmentList (Synchronous)

- (EZPShipmentList *)next {
   self.filters = self.filters ? self.filters : [NSMutableDictionary dictionary];
   self.filters[@"before_id"] = [self.shipments lastObject].itemId;
   
   return [EZPShipment list:self.filters];
}

@end
