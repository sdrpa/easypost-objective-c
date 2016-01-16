
// Created by Sinisa Drpa, 2015.

#import "EZPBatch.h"

@interface EZPBatch (Synchronous)

+ (EZPBatch *)create:(NSDictionary *)parameters;
+ (EZPBatch *)retrieve:(NSString *)itemId;
- (void)addShipmentsWithShipments:(NSArray *)shipments;
- (void)addShipments:(NSArray *)shipmentIds;

@end
